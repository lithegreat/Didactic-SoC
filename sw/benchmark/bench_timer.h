/*
 * bench_timer.h
 * -------------
 * RISC-V mcycle CSR helpers for cycle-accurate benchmarking on the Ibex core.
 *
 * STATUS: mcycle IS accessible in this SoC build.  Although the Ibex is
 * instantiated with MHPMCounterNum=0 (no additional HPM3-31 counters),
 * ibex_cs_registers.sv always includes CSR_MCYCLE (0xB00) and CSR_MCYCLEH
 * (0xB80) in its decode path without guarding them on MHPMCounterNum.
 * Firmware reads return the current 64-bit cycle counter value.
 *
 * Usage:
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
