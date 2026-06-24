/*
 * benchmark_gemm.c
 * ----------------
 * CPU-only GEMM shim for the benchmark.  Defined in its own translation unit
 * so the accel_gemm_data.h arrays (accel_A, accel_B, accel_golden) are shared
 * with the accel driver TUs via the linker's duplicate-elimination: each TU
 * gets its own static copy, but --gc-sections removes unused ones.
 *
 * bench_cpu_gemm() performs the same INT8→INT32 accumulation as the hardware:
 *   out[i*N+j] = sum_k  A[i*K+k] * B[k*N+j]   (int32_t, wraps on overflow)
 *
 * Contributor(s):
 *   - Group5 (TUM systolic-array AI accelerator)
 */

#include <stdint.h>

#include "accel_gemm_data.h"  /* accel_A, accel_B, ACC_M, ACC_N, ACC_K */

/*
 * bench_cpu_gemm
 * --------------
 * Write ACC_M × ACC_N int32_t results into 'out' (row-major).
 * 'out' must point to a buffer of at least ACC_M * ACC_N int32_t elements.
 */
void bench_cpu_gemm(volatile int32_t *out) {
    for (int i = 0; i < ACC_M; i++) {
        for (int j = 0; j < ACC_N; j++) {
            int32_t s = 0;
            for (int k = 0; k < ACC_K; k++) {
                s += (int32_t)accel_A[i * ACC_K + k] *
                     (int32_t)accel_B[k * ACC_N + j];
            }
            out[i * ACC_N + j] = s;
        }
    }
}
