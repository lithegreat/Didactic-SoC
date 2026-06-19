#ifndef __ACCEL_TILED_GEMM_H__
#define __ACCEL_TILED_GEMM_H__

#include <stdint.h>

#include "accel_driver.h"

void accel_clear_accum(volatile uint32_t accum[ACC_M * ACC_N]);
accel_tile_status_t accel_run_tiled_gemm(volatile uint32_t accum[ACC_M * ACC_N]);
uint32_t accel_count_mismatches(volatile uint32_t accum[ACC_M * ACC_N]);

#endif // __ACCEL_TILED_GEMM_H__