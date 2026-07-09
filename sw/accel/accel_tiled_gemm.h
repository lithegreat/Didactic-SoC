#ifndef __ACCEL_TILED_GEMM_H__
#define __ACCEL_TILED_GEMM_H__

#include <stdint.h>

#include "accel_driver.h"

void accel_clear_accum(volatile uint32_t accum[ACC_M * ACC_N]);

/* use_double_buffer == 0: run tiles sequentially (write, compute, read back,
 *   one tile at a time — matrix_buffer_ab/c bank 0 only).
 * use_double_buffer != 0: pipeline tiles across the matrix buffers' two
 *   banks — while one bank streams/computes the current tile, the next
 *   tile's A/B is loaded into the other bank, and a completed C bank is read
 *   back over APB while the next tile's result is captured into the other
 *   bank. See docs/interface/matrix_buffer_a_b_if.md and matrix_buffer_c_if.md
 *   ("Double buffering (2-bank)") for the MAT_CTRL bank-select semantics.
 * Both paths produce identical results; only APB/compute overlap differs. */
accel_tile_status_t accel_run_tiled_gemm(volatile uint32_t accum[ACC_M * ACC_N],
                                         accel_perf_t *perf,
                                         int use_double_buffer);
uint32_t accel_count_mismatches(volatile uint32_t accum[ACC_M * ACC_N]);

#endif // __ACCEL_TILED_GEMM_H__