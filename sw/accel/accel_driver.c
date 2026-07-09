#include "accel_driver.h"

#include "accel_regs.h"

uint32_t accel_min_u32(uint32_t a, uint32_t b) { return (a < b) ? a : b; }

uint32_t accel_expected_build_info(void) {
  return ((uint32_t)ACC_DATA_W << 24) | ((uint32_t)ACC_K << 16) | ((uint32_t)ACC_N << 8) |
         (uint32_t)ACC_M;
}

int accel_build_info_matches(void) { return REG_BUILD_INFO == accel_expected_build_info(); }

#if ACCEL_ELEMS_PER_WORD != 4
static void write_packed_element(
    volatile uint32_t *dst,
    uint32_t *word,
    uint32_t *lane,
    uint32_t elem) {
  *word |= (elem & ACCEL_DATA_MASK) << ((*lane) * ACC_DATA_W);
  (*lane)++;
  if (*lane == ACCEL_ELEMS_PER_WORD) {
    *dst = *word;
    *word = 0u;
    *lane = 0u;
  }
}

static void flush_packed_tail(volatile uint32_t *dst, uint32_t *word, uint32_t *lane) {
  if (*lane != 0u) {
    *dst = *word;
    *word = 0u;
    *lane = 0u;
  }
}
#endif /* ACCEL_ELEMS_PER_WORD != 4 */

void write_a_tile(const accel_tile_t *tile) {
#if ACCEL_ELEMS_PER_WORD == 4
  /* INT8 fast path: pointer walk, 4 elements packed per store, no per-element branch. */
  const int8_t   *pa       = &accel_A[tile->m0 * ACC_K + tile->k0];
  const uint32_t row_skip  = ACC_K - tile->k;
  const uint32_t n_words   = tile->k / 4u;
  for (uint32_t i = 0; i < tile->m; i++) {
    for (uint32_t w = 0; w < n_words; w++) {
      *MAT_A_DATA_REG = ((uint32_t)(uint8_t)pa[0])
                      | ((uint32_t)(uint8_t)pa[1] << 8)
                      | ((uint32_t)(uint8_t)pa[2] << 16)
                      | ((uint32_t)(uint8_t)pa[3] << 24);
      pa += 4;
    }
    pa += row_skip;
  }
#else
  uint32_t word = 0u;
  uint32_t lane = 0u;
  for (uint32_t i = 0; i < tile->m; i++) {
    for (uint32_t k = 0; k < tile->k; k++) {
      uint32_t elem = (uint32_t)accel_A[(tile->m0 + i) * ACC_K + (tile->k0 + k)];
      write_packed_element(MAT_A_DATA_REG, &word, &lane, elem);
    }
  }
  flush_packed_tail(MAT_A_DATA_REG, &word, &lane);
#endif
}

void write_b_tile(const accel_tile_t *tile) {
#if ACCEL_ELEMS_PER_WORD == 4
  /* INT8 fast path: pointer walk, 4 elements packed per store, no per-element branch. */
  const int8_t   *pb       = &accel_B[tile->k0 * ACC_N + tile->n0];
  const uint32_t row_skip  = ACC_N - tile->n;
  const uint32_t n_words   = tile->n / 4u;
  for (uint32_t k = 0; k < tile->k; k++) {
    for (uint32_t w = 0; w < n_words; w++) {
      *MAT_B_DATA_REG = ((uint32_t)(uint8_t)pb[0])
                      | ((uint32_t)(uint8_t)pb[1] << 8)
                      | ((uint32_t)(uint8_t)pb[2] << 16)
                      | ((uint32_t)(uint8_t)pb[3] << 24);
      pb += 4;
    }
    pb += row_skip;
  }
#else
  uint32_t word = 0u;
  uint32_t lane = 0u;
  for (uint32_t k = 0; k < tile->k; k++) {
    for (uint32_t j = 0; j < tile->n; j++) {
      uint32_t elem = (uint32_t)accel_B[(tile->k0 + k) * ACC_N + (tile->n0 + j)];
      write_packed_element(MAT_B_DATA_REG, &word, &lane, elem);
    }
  }
  flush_packed_tail(MAT_B_DATA_REG, &word, &lane);
#endif
}

int wait_done(void) {
  uint32_t timeout = 1000000u;
  while (((REG_STATUS & STATUS_DONE_BIT) == 0u) && (timeout != 0u)) {
    timeout--;
  }
  return timeout != 0u;
}

static int perf_vals_sane(
    const accel_tile_t *tile,
    uint32_t cycles, uint32_t apb_writes, uint32_t apb_reads,
    uint32_t out_stalls, uint32_t hw_status) {
  return (cycles != 0u) && (apb_writes != 0u) && (apb_reads >= (tile->m * tile->n)) &&
         (out_stalls == 0u) &&
         ((hw_status & (HW_STATUS_OUT_STALL_SEEN_BIT | HW_STATUS_COUNTER_OVERFLOW_BIT)) == 0u);
}

accel_tile_status_t accel_run_tile(
    const accel_tile_t *tile,
    volatile uint32_t accum[ACC_M * ACC_N],
    accel_perf_t *perf) {
  /* Clear perf counters BEFORE data load so all APB transactions are captured. */
  REG_PERF_CTRL = PERF_CLEAR_BIT;

  MAT_AB_CTRL = MAT_CTRL_RESET_BIT;
  MAT_C_CTRL = MAT_CTRL_RESET_BIT;

  REG_M_DIM = tile->m;
  REG_N_DIM = tile->n;
  REG_K_DIM = tile->k;

  write_a_tile(tile);
  write_b_tile(tile);

  REG_CTRL = CTRL_START_BIT;

  if (!wait_done()) {
    return ACCEL_TILE_TIMEOUT;
  }

  {
    /* Accumulate rather than overwrite: when the caller tiles the K dimension
     * (ACCEL_TILE_K_CAP < ACC_K), the same (m0,n0) output block is visited
     * once per k-tile and each hardware run only covers a K sub-range, so
     * partial sums must be added together. The caller is responsible for
     * zeroing accum once before the first tile (accel_run_tiled_gemm does
     * this), so this is equivalent to a plain overwrite when there is only
     * one k-tile. */
    volatile uint32_t *p_row = &accum[tile->m0 * ACC_N + tile->n0];
    for (uint32_t i = 0; i < tile->m; i++) {
      volatile uint32_t *p = p_row;
      for (uint32_t j = 0; j < tile->n; j++) {
        *p = *p + MAT_C_DATA;
        p++;
      }
      p_row += ACC_N;
    }
  }

  /* Snapshot counters before the sanity-check reads (which are also APB reads). */
  const uint32_t tile_cycles     = REG_PERF_CYCLES;
  const uint32_t tile_apb_writes = REG_PERF_APB_WRITES;
  const uint32_t tile_apb_reads  = REG_PERF_APB_READS;
  const uint32_t tile_out_stalls = REG_PERF_OUT_STALLS;
  const uint32_t tile_hw_status  = REG_HW_STATUS;

  if (perf) {
    perf->compute_cycles += tile_cycles;
    perf->apb_writes     += tile_apb_writes;
    perf->apb_reads      += tile_apb_reads;
  }

  accel_tile_status_t status =
      perf_vals_sane(tile, tile_cycles, tile_apb_writes, tile_apb_reads,
                     tile_out_stalls, tile_hw_status)
          ? ACCEL_TILE_OK
          : ACCEL_TILE_PERF_FAIL;
  REG_STATUS = STATUS_DONE_BIT;
  return status;
}