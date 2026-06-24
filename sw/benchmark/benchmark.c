/*
 * benchmark.c
 * -----------
 * CPU vs. CPU+Accelerator GEMM benchmark for the TUM systolic-array AI
 * accelerator inside the Edu4Chip Didactic SoC.
 *
 * Timing strategy
 * ---------------
 * The Ibex instance in this SoC does not expose mcycle/minstret over its
 * APB slave port, so cycle counting uses the accelerator's own hardware
 * performance counter (REG_PERF_CYCLES) for the accelerator path, and a
 * manually counted iteration counter for the CPU path.
 *
 * CPU GEMM cost is estimated as:
 *   cpu_iter_count * CPU_CYCLES_PER_ITER
 * where CPU_CYCLES_PER_ITER is calibrated from the Ibex pipeline model:
 *   inner-loop body ≈ 4 instructions (mul + add + index + branch) at
 *   roughly 1 CPI = 4 cycles; outer loop overhead ~2 cycles per K step.
 *
 * Accelerator GEMM cost is the exact value from REG_PERF_CYCLES (hardware
 * cycles consumed by the systolic array, excluding APB overhead).
 *
 * UART output
 * -----------
 *   benchmark: start
 *   cpu est cyc: <N>  (<N> inner iters)
 *   hw cycles:   <N>
 *   speedup: <int>.<2-digit>x
 *   benchmark: PASS
 *
 * Result code (DMEM[0], observed by the testbench)
 * --------------------------------------------------
 *   0xACCE5500  PASS  (matches the testbench RESULT_PASS criterion)
 *   0xBADD0001  accelerator timeout
 *   0xBADD0002  build-info mismatch
 *   0xBADD0003  accelerator perf-counter sanity fail
 *   0xBADD0005  accelerator result mismatch
 *
 * Contributors:
 *   - Group5 (TUM systolic-array AI accelerator)
 */

#include <stdint.h>

#include "accel_driver.h"
#include "accel_gemm_data.h"   /* ACC_M / ACC_N / ACC_K — dimension macros only */
#include "accel_regs.h"
#include "accel_tiled_gemm.h"
#include "soc_ctrl.h"
#include "uart.h"

/* -------------------------------------------------------------------------
 * bench_result MUST be the FIRST word in DMEM (0x01010000 = DMEM[0]).
 * The Verilator testbench polls DMEM[0] for 0xACCE5500 (PASS) or
 * 0xBADDxxxx (FAIL).  postMain() in crt0.S also forwards this value to
 * the SoC status register at 0x0102_0380.
 *
 * Placement: link.ld puts .data first in DMEM.  Initialising to 0 would
 * put it in .bss (after other BSS symbols).  Instead we initialise to a
 * non-zero sentinel so it goes into .data and lands at DMEM[0].
 * We overwrite it before returning.
 * ------------------------------------------------------------------------- */
volatile uint32_t bench_result = 0xDEAD0000u;

/* Estimated Ibex cycles per inner-loop body of the CPU GEMM:
 *   lw/lb  A[i*K+k]   ~2 cyc
 *   lw/lb  B[k*N+j]   ~2 cyc
 *   mul               ~1 cyc  (RV32M fast multiplier)
 *   add               ~1 cyc
 *   loop overhead     ~2 cyc  (branch + index increments)
 * Total ≈ 8 cycles per (i,j,k) triple.
 */
#define CPU_CYCLES_PER_ITER 8u

/* -------------------------------------------------------------------------
 * Minimal unsigned decimal printer (no printf in nostdlib).
 * Prints 'v' then 'suffix' over UART.
 * ------------------------------------------------------------------------- */
static void print_u32(uint32_t v, const char *sfx) {
    char buf[11];
    int i = 0;
    if (v == 0u) {
        buf[i++] = '0';
    } else {
        for (uint32_t t = v; t > 0u; t /= 10u)
            buf[i++] = (char)('0' + (int)(t % 10u));
        for (int l = 0, r = i - 1; l < r; l++, r--) {
            char tmp = buf[l]; buf[l] = buf[r]; buf[r] = tmp;
        }
    }
    buf[i] = '\0';
    uart_print(buf);
    uart_print(sfx);
}

/* Print "<int>.<2-digit>x\n" for a speedup expressed in hundredths. */
static void print_speedup(uint32_t sx100) {
    print_u32(sx100 / 100u, ".");
    char f[3];
    f[0] = (char)('0' + (int)((sx100 % 100u) / 10u));
    f[1] = (char)('0' + (int)((sx100 % 100u) % 10u));
    f[2] = '\0';
    uart_print(f);
    uart_print("x\n");
}

/* -------------------------------------------------------------------------
 * Output buffers in .bss (DMEM).  bench_result is in .data so it lands
 * at DMEM[0] before these BSS symbols.
 * ------------------------------------------------------------------------- */
static volatile uint32_t accum[ACC_M * ACC_N];

/* -------------------------------------------------------------------------
 * CPU-only GEMM shim (defined in benchmark_gemm.c to keep this TU small).
 * ------------------------------------------------------------------------- */
extern void bench_cpu_gemm(volatile int32_t *out);

/* -------------------------------------------------------------------------
 * main
 * ------------------------------------------------------------------------- */
int main(void) {
    uart_init();
    uart_print("benchmark: start\n");

    ss_init(ACCEL_SS);

    if (!accel_build_info_matches()) {
        uart_print("benchmark: BUILD INFO MISMATCH\n");
        bench_result = 0xBADD0002u;
        return 2;
    }

    /* ------------------------------------------------------------------ *
     * PATH A — CPU GEMM (estimated cycle count)                           *
     * ------------------------------------------------------------------ */
    static volatile int32_t cpu_out[ACC_M * ACC_N];

    /* Run the CPU GEMM and count inner iterations. */
    volatile uint32_t inner_iters = 0u;
    for (int i = 0; i < ACC_M; i++) {
        for (int j = 0; j < ACC_N; j++) {
            int32_t s = 0;
            for (int k = 0; k < ACC_K; k++) {
                s += (int32_t)accel_A[i * ACC_K + k] *
                     (int32_t)accel_B[k * ACC_N + j];
                inner_iters++;
            }
            cpu_out[i * ACC_N + j] = s;
        }
    }

    uint32_t cpu_est_cyc = inner_iters * CPU_CYCLES_PER_ITER;
    print_u32(inner_iters, " inner iters  ");
    print_u32(cpu_est_cyc, " cyc (est)  <- cpu gemm\n");

    /* ------------------------------------------------------------------ *
     * PATH B — Accelerator GEMM (hardware cycle counter)                 *
     * ------------------------------------------------------------------ */
    accel_clear_accum(accum);
    accel_tile_status_t st = accel_run_tiled_gemm(accum);

    if (st == ACCEL_TILE_TIMEOUT) {
        uart_print("benchmark: TIMEOUT\n");
        bench_result = 0xBADD0001u;
        return 1;
    }
    if (st != ACCEL_TILE_OK) {
        uart_print("benchmark: PERF FAIL\n");
        bench_result = 0xBADD0003u;
        return 3;
    }

    uint32_t hw_cyc = REG_PERF_CYCLES;

    if (accel_count_mismatches(accum) != 0u) {
        uart_print("benchmark: ACCEL MISMATCH\n");
        bench_result = 0xBADD0005u;
        return 5;
    }

    print_u32(hw_cyc, " cyc  <- hw (accel only, from REG_PERF_CYCLES)\n");

    /* ------------------------------------------------------------------ *
     * Speedup = floor((cpu_est_cyc * 100) / hw_cyc)                      *
     * ------------------------------------------------------------------ */
    uint32_t sx100 = (hw_cyc > 0u) ? (cpu_est_cyc * 100u) / hw_cyc : 0u;
    uart_print("speedup: ");
    print_speedup(sx100);

    uart_print("benchmark: PASS\n");

    /* Use 0xACCE5500 so the existing testbench recognizes PASS. */
    bench_result = 0xACCE5500u;
    return 0;
}
