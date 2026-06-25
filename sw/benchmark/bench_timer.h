1/*
 * bench_timer.h
 * -------------
 * RISC-V mcycle CSR helpers for cycle-accurate benchmarking on the Ibex core.
 *
 * STATUS: Ibex in the Edu4Chip Didactic SoC raises an illegal-instruction
 * exception when firmware reads mcycle/minstret.  Root cause: the Ibex
 * instance is instantiated with MHPMCounterNum=0 and the elaborated Verilator
 * model routes those CSR addresses to the default-illegal branch of the
 * unique case in ibex_cs_registers.sv.
 *
 * These helpers are RETAINED here for reference and for future SoC builds
 * where the CSR is accessible (e.g. with the RISC-V Ibex configured with
 * MHPMCounterNum > 0 or a different RISC-V core), but benchmark.c
 * currently uses the accelerator's REG_PERF_CYCLES counter and an
 * instruction-iteration estimator instead.
 *
 * Usage (when available):
 *   uint32_t t0 = bench_cycles_lo();
 *   // ... timed code ...
 *   uint32_t elapsed = bench_elapsed_lo(t0);
 *
 * Contributor(s):
 *   - Group5 (TUM systolic-array AI accelerator)
 */

#ifndef __BENCH_TIMER_H__
#define __BENCH_TIMER_H__

#include <stdint.h>

/*
 * bench_cycles_lo - Read the lower 32 bits of mcycle.
 * NOTE: May raise an illegal-instruction exception on some Ibex builds.
 */
static inline uint32_t bench_cycles_lo(void) {
    uint32_t c;
    asm volatile("csrr %0, mcycle" : "=r"(c));
    return c;
}

/*
 * bench_elapsed_lo - Elapsed cycles since 'start' (32-bit, unsigned wrap).
 */
static inline uint32_t bench_elapsed_lo(uint32_t start) {
    return bench_cycles_lo() - start;
}

#endif /* __BENCH_TIMER_H__ */
