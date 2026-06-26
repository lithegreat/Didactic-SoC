/*
 * benchmark.c
 * -----------
 * CPU vs. CPU+Accelerator GEMM benchmark for the TUM systolic-array AI
 * accelerator inside the Edu4Chip Didactic SoC.
 *
 * Timing strategy
 * ---------------
 * Hardware perf counters (REG_PERF_CYCLES / REG_PERF_APB_WRITES/READS) give
 * an exact breakdown of the accelerator path into compute and bus components.
 * mcycle is not accessible in this Ibex build (MHPMCounterNum=0 disables it
 * at the Verilator level despite the RTL case entry).  Total wall-clock cycles
 * for both paths are reported by the simulation script via Ibex trace analysis.
 *
 * UART output (firmware)
 * ----------------------
 *   benchmark: start
 *   compute: <N> cyc  (REG_PERF_CYCLES, accel only)
 *   bus:     <N> cyc  (<N> wr + <N> rd) x2
 *   benchmark: PASS
 *
 * Additional wall-clock breakdown printed by verilate_soc_benchmark.py:
 *   CPU GEMM:   <N> cyc  (trace: first->last store to cpu_out)
 *   Accel path: <N> cyc  (trace: accel_clear_accum->tiled_gemm return)
 *   Speedup:    X.XXx
 *
 * Result code (DMEM[0], observed by the testbench)
 * --------------------------------------------------
 *   0xACCE5500  PASS
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

#ifndef BENCH_SKIP_BUILD_INFO
    if (!accel_build_info_matches()) {
        uart_print("benchmark: BUILD INFO MISMATCH\n");
        bench_result = 0xBADD0002u;
        return 2;
    }
#endif

    /* ------------------------------------------------------------------ *
     * PATH A — CPU GEMM (run for wall-clock reference; sim script times it)
     * ------------------------------------------------------------------ */
    static volatile int32_t cpu_out[ACC_M * ACC_N];

    for (int i = 0; i < ACC_M; i++) {
        for (int j = 0; j < ACC_N; j++) {
            int32_t s = 0;
            for (int k = 0; k < ACC_K; k++) {
                s += (int32_t)accel_A[i * ACC_K + k] *
                     (int32_t)accel_B[k * ACC_N + j];
            }
            cpu_out[i * ACC_N + j] = s;
        }
    }

    /* ------------------------------------------------------------------ *
     * PATH B — Accelerator GEMM (hardware perf counters)                 *
     * ------------------------------------------------------------------ */
    accel_perf_t accel_perf;
    accel_tile_status_t st = accel_run_tiled_gemm(accum, &accel_perf);

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

    if (accel_count_mismatches(accum) != 0u) {
        uart_print("benchmark: ACCEL MISMATCH\n");
        bench_result = 0xBADD0005u;
        return 5;
    }

    /*
     * Hardware breakdown:
     *   compute = REG_PERF_CYCLES (systolic array START→DONE, all tiles)
     *   bus     = (APB writes + reads) × 2 clk  (PREADY=1, no wait states)
     * SW overhead (loop control, packing, accumulation) is reported by
     * verilate_soc_benchmark.py from the Ibex instruction trace.
     */
    uint32_t compute_cyc = accel_perf.compute_cycles;
    uint32_t bus_cyc     = (accel_perf.apb_writes + accel_perf.apb_reads) * 2u;

    uart_print("compute: ");
    print_u32(compute_cyc, " cyc  (REG_PERF_CYCLES, accel)\n");
    uart_print("bus:     ");
    print_u32(bus_cyc, " cyc  (");
    print_u32(accel_perf.apb_writes, " wr + ");
    print_u32(accel_perf.apb_reads,  " rd) x2\n");

    uart_print("benchmark: PASS\n");

    /* Use 0xACCE5500 so the existing testbench recognizes PASS. */
    bench_result = 0xACCE5500u;
    return 0;
}
