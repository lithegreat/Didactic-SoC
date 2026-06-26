#ifndef __ACCEL_DRIVER_H__
#define __ACCEL_DRIVER_H__

#include <stdint.h>

#include "accel_gemm_data.h"

#define ACCEL_ELEMS_PER_WORD (32u / ACC_DATA_W)

#if ACC_DATA_W >= 32
#define ACCEL_DATA_MASK 0xFFFFFFFFu
#else
#define ACCEL_DATA_MASK ((1u << ACC_DATA_W) - 1u)
#endif

typedef enum {
  ACCEL_TILE_OK = 0,
  ACCEL_TILE_TIMEOUT = 1,
  ACCEL_TILE_PERF_FAIL = 2,
} accel_tile_status_t;

typedef struct {
  uint32_t m0;
  uint32_t n0;
  uint32_t k0;
  uint32_t m;
  uint32_t n;
  uint32_t k;
} accel_tile_t;

/* Accumulated hardware performance counters across all tiles. */
typedef struct {
  uint32_t compute_cycles; /* sum of REG_PERF_CYCLES (START→DONE) across tiles */
  uint32_t apb_writes;     /* sum of REG_PERF_APB_WRITES (all writes incl. load) */
  uint32_t apb_reads;      /* sum of REG_PERF_APB_READS  (status polls + C read) */
} accel_perf_t;

uint32_t accel_min_u32(uint32_t a, uint32_t b);
uint32_t accel_expected_build_info(void);
int accel_build_info_matches(void);
accel_tile_status_t accel_run_tile(
    const accel_tile_t *tile,
    volatile uint32_t accum[ACC_M * ACC_N],
    accel_perf_t *perf);

#endif // __ACCEL_DRIVER_H__