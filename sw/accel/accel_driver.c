#include "accel_driver.h"

#include "accel_regs.h"

uint32_t accel_min_u32(uint32_t a, uint32_t b) { return (a < b) ? a : b; }

uint32_t accel_expected_build_info(void) {
  return ((uint32_t)ACC_DATA_W << 24) | ((uint32_t)ACC_K << 16) | ((uint32_t)ACC_N << 8) |
         (uint32_t)ACC_M;
}

int accel_build_info_matches(void) { return REG_BUILD_INFO == accel_expected_build_info(); }

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

static void write_a_tile(const accel_tile_t *tile) {
  uint32_t word = 0u;
  uint32_t lane = 0u;

  for (uint32_t i = 0; i < tile->m; i++) {
    for (uint32_t k = 0; k < tile->k; k++) {
      uint32_t elem = (uint32_t)accel_A[(tile->m0 + i) * ACC_K + (tile->k0 + k)];
      write_packed_element(MAT_A_DATA_REG, &word, &lane, elem);
    }
  }
  flush_packed_tail(MAT_A_DATA_REG, &word, &lane);
}

static void write_b_tile(const accel_tile_t *tile) {
  uint32_t word = 0u;
  uint32_t lane = 0u;

  for (uint32_t k = 0; k < tile->k; k++) {
    for (uint32_t j = 0; j < tile->n; j++) {
      uint32_t elem = (uint32_t)accel_B[(tile->k0 + k) * ACC_N + (tile->n0 + j)];
      write_packed_element(MAT_B_DATA_REG, &word, &lane, elem);
    }
  }
  flush_packed_tail(MAT_B_DATA_REG, &word, &lane);
}

static int wait_done(void) {
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

  for (uint32_t i = 0; i < tile->m; i++) {
    for (uint32_t j = 0; j < tile->n; j++) {
      uint32_t partial = MAT_C_DATA;
      accum[(tile->m0 + i) * ACC_N + (tile->n0 + j)] += partial;
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