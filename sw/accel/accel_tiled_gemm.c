#include "accel_tiled_gemm.h"

#include "accel_gemm_data.h"

enum {
  ACCEL_TILE_M_CAP = 8u,
  ACCEL_TILE_N_CAP = 8u,
  ACCEL_TILE_K_CAP = 8u,
};

void accel_clear_accum(volatile uint32_t accum[ACC_M * ACC_N]) {
  for (uint32_t idx = 0; idx < (ACC_M * ACC_N); idx++) {
    accum[idx] = 0u;
  }
}

accel_tile_status_t accel_run_tiled_gemm(volatile uint32_t accum[ACC_M * ACC_N],
                                         accel_perf_t *perf) {
  if (perf) {
    perf->compute_cycles = 0u;
    perf->apb_writes     = 0u;
    perf->apb_reads      = 0u;
  }

  const uint32_t tile_m_cap = accel_min_u32(ACCEL_TILE_M_CAP, ACC_M);
  const uint32_t tile_n_cap = accel_min_u32(ACCEL_TILE_N_CAP, ACC_N);
  const uint32_t tile_k_cap = accel_min_u32(ACCEL_TILE_K_CAP, ACC_K);

  for (uint32_t m0 = 0; m0 < ACC_M; m0 += tile_m_cap) {
    for (uint32_t n0 = 0; n0 < ACC_N; n0 += tile_n_cap) {
      for (uint32_t k0 = 0; k0 < ACC_K; k0 += tile_k_cap) {
        const accel_tile_t tile = {
            .m0 = m0,
            .n0 = n0,
            .k0 = k0,
            .m = accel_min_u32(tile_m_cap, ACC_M - m0),
            .n = accel_min_u32(tile_n_cap, ACC_N - n0),
            .k = accel_min_u32(tile_k_cap, ACC_K - k0),
        };
        accel_tile_status_t status = accel_run_tile(&tile, accum, perf);
        if (status != ACCEL_TILE_OK) {
          return status;
        }
      }
    }
  }

  return ACCEL_TILE_OK;
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