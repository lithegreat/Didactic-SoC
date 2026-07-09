#include "accel_tiled_gemm.h"

#include "accel_gemm_data.h"
#include "accel_regs.h"

/* Runtime tile size caps. Default to the full physical array (one tile,
 * matching the historical behaviour) — override at compile time, e.g.
 * -DACCEL_TILE_M_CAP=8 -DACCEL_TILE_N_CAP=8 -DACCEL_TILE_K_CAP=8, to exercise
 * multi-tile pipelining (double buffering) on hardware built for a larger
 * physical array. */
#ifndef ACCEL_TILE_M_CAP
#define ACCEL_TILE_M_CAP ACC_M
#endif
#ifndef ACCEL_TILE_N_CAP
#define ACCEL_TILE_N_CAP ACC_N
#endif
#ifndef ACCEL_TILE_K_CAP
#define ACCEL_TILE_K_CAP ACC_K
#endif

#define ACCEL_CEIL_DIV(a, b) (((a) + (b)-1u) / (b))
#define ACCEL_MAX_TILES                                          \
  (ACCEL_CEIL_DIV((uint32_t)ACC_M, (uint32_t)ACCEL_TILE_M_CAP) *  \
   ACCEL_CEIL_DIV((uint32_t)ACC_N, (uint32_t)ACCEL_TILE_N_CAP) *  \
   ACCEL_CEIL_DIV((uint32_t)ACC_K, (uint32_t)ACCEL_TILE_K_CAP))

void accel_clear_accum(volatile uint32_t accum[ACC_M * ACC_N]) {
  for (uint32_t idx = 0; idx < (ACC_M * ACC_N); idx++) {
    accum[idx] = 0u;
  }
}

static uint32_t build_tile_list(accel_tile_t tiles[ACCEL_MAX_TILES]) {
  const uint32_t tile_m_cap = accel_min_u32(ACCEL_TILE_M_CAP, ACC_M);
  const uint32_t tile_n_cap = accel_min_u32(ACCEL_TILE_N_CAP, ACC_N);
  const uint32_t tile_k_cap = accel_min_u32(ACCEL_TILE_K_CAP, ACC_K);

  uint32_t num_tiles = 0u;
  for (uint32_t m0 = 0; m0 < ACC_M; m0 += tile_m_cap) {
    for (uint32_t n0 = 0; n0 < ACC_N; n0 += tile_n_cap) {
      for (uint32_t k0 = 0; k0 < ACC_K; k0 += tile_k_cap) {
        tiles[num_tiles++] = (accel_tile_t){
            .m0 = m0,
            .n0 = n0,
            .k0 = k0,
            .m = accel_min_u32(tile_m_cap, ACC_M - m0),
            .n = accel_min_u32(tile_n_cap, ACC_N - n0),
            .k = accel_min_u32(tile_k_cap, ACC_K - k0),
        };
      }
    }
  }
  return num_tiles;
}

/* Sequential, single-bank path: write, compute, and read back one tile at a
 * time (matrix_buffer_ab/c bank 0 only). */
static accel_tile_status_t run_tiled_gemm_single(
    const accel_tile_t *tiles, uint32_t num_tiles,
    volatile uint32_t accum[ACC_M * ACC_N], accel_perf_t *perf) {
  for (uint32_t t = 0; t < num_tiles; t++) {
    accel_tile_status_t status = accel_run_tile(&tiles[t], accum, perf);
    if (status != ACCEL_TILE_OK) {
      return status;
    }
  }
  return ACCEL_TILE_OK;
}

/* Pipelined, double-buffered path: while bank `cur` streams/computes tile
 * `t`, tile `t+1`'s A/B is loaded into bank `next`; tile `t`'s C result is
 * then read back over APB from its capture bank while tile `t+1` computes
 * into the other C bank. See docs/interface/matrix_buffer_a_b_if.md and
 * matrix_buffer_c_if.md ("Double buffering (2-bank)") for the exact
 * MAT_CTRL bit semantics used below. */
static accel_tile_status_t run_tiled_gemm_double_buffered(
    const accel_tile_t *tiles, uint32_t num_tiles,
    volatile uint32_t accum[ACC_M * ACC_N], accel_perf_t *perf) {
  REG_PERF_CTRL = PERF_CLEAR_BIT;

  /* Load tile 0 into AB bank 0 and reset C bank 0. */
  MAT_AB_CTRL = MAT_CTRL_RESET_BIT;
  MAT_C_CTRL = MAT_CTRL_RESET_BIT;

  REG_M_DIM = tiles[0].m;
  REG_N_DIM = tiles[0].n;
  REG_K_DIM = tiles[0].k;
  write_a_tile(&tiles[0]);
  write_b_tile(&tiles[0]);

  REG_CTRL = CTRL_START_BIT;

  for (uint32_t t = 0; t < num_tiles; t++) {
    const uint32_t cur_bank = t & 1u;
    const uint32_t next_bank = (t + 1u) & 1u;
    const int has_next = (t + 1u) < num_tiles;

    if (has_next) {
      /* Stream/compute tile t from cur_bank while staging tile t+1's A/B
       * into next_bank. */
      MAT_AB_CTRL = (cur_bank << 4) | (next_bank << 3);
      MAT_AB_CTRL = (cur_bank << 4) | (next_bank << 3) | MAT_CTRL_RESET_BIT;

      REG_M_DIM = tiles[t + 1].m;
      REG_N_DIM = tiles[t + 1].n;
      REG_K_DIM = tiles[t + 1].k;
      write_a_tile(&tiles[t + 1]);
      write_b_tile(&tiles[t + 1]);
    }

    if (!wait_done()) {
      return ACCEL_TILE_TIMEOUT;
    }

    if (perf) {
      perf->compute_cycles += REG_PERF_CYCLES;
      perf->apb_writes += REG_PERF_APB_WRITES;
      perf->apb_reads += REG_PERF_APB_READS;
    }
    REG_PERF_CTRL = PERF_CLEAR_BIT;
    REG_STATUS = STATUS_DONE_BIT;

    if (has_next) {
      /* Tile t+1's A/B is now fully staged in next_bank: start streaming
       * from it and start computing tile t+1, while APB read-back for
       * tile t stays pointed at cur_bank of the C buffer. */
      MAT_AB_CTRL = (next_bank << 4) | (next_bank << 3);

      MAT_C_CTRL = (next_bank << 4) | (next_bank << 3);
      MAT_C_CTRL = (next_bank << 4) | (next_bank << 3) | MAT_CTRL_RESET_BIT;
      MAT_C_CTRL = (next_bank << 4) | (cur_bank << 3);

      REG_CTRL = CTRL_START_BIT;
    } else {
      MAT_C_CTRL = (cur_bank << 4) | (cur_bank << 3);
    }

    /* Read tile t's result back from cur_bank while tile t+1 computes. */
    volatile uint32_t *p_row = &accum[tiles[t].m0 * ACC_N + tiles[t].n0];
    for (uint32_t i = 0; i < tiles[t].m; i++) {
      volatile uint32_t *p = p_row;
      for (uint32_t j = 0; j < tiles[t].n; j++) {
        *p = *p + MAT_C_DATA;
        p++;
      }
      p_row += ACC_N;
    }
  }

  return ACCEL_TILE_OK;
}

accel_tile_status_t accel_run_tiled_gemm(volatile uint32_t accum[ACC_M * ACC_N],
                                         accel_perf_t *perf,
                                         int use_double_buffer) {
  if (perf) {
    perf->compute_cycles = 0u;
    perf->apb_writes = 0u;
    perf->apb_reads = 0u;
  }

  accel_clear_accum(accum);

  accel_tile_t tiles[ACCEL_MAX_TILES];
  const uint32_t num_tiles = build_tile_list(tiles);
  if (num_tiles == 0u) {
    return ACCEL_TILE_OK;
  }

  return use_double_buffer
             ? run_tiled_gemm_double_buffered(tiles, num_tiles, accum, perf)
             : run_tiled_gemm_single(tiles, num_tiles, accum, perf);
}

uint32_t accel_count_mismatches(volatile uint32_t accum[ACC_M * ACC_N]) {
  uint32_t mismatches = 0u;
  for (uint32_t idx = 0; idx < (ACC_M * ACC_N); idx++) {
    if ((int32_t)accum[idx] != accel_golden[idx]) {
      mismatches++;
    }
  }
  return mismatches;
}