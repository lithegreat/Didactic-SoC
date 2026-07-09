#ifndef __ACCEL_REGS_H__
#define __ACCEL_REGS_H__

#include <stdint.h>

// TUM subsystem slot index and accelerator APB base address.
// New Didactic-SoC address map: 0x015X_0000 with X = slot index (1-7).
// Slot 1 (TUM group5) -> 0x0151_0000; the ICN strips the upper prefix,
// so the 16-bit PADDR reaching accelerator_top starts at 0x0000.
#define ACCEL_SS 1
#define ACCEL_BASE 0x01510000u

#define ACCEL_REG32(addr) (*(volatile uint32_t *)(addr))

// matrix_buffer_ab (PADDR[9:8] == 00)
#define MAT_A_DATA_REG ((volatile uint32_t *)(ACCEL_BASE + 0x000u))
#define MAT_B_DATA_REG ((volatile uint32_t *)(ACCEL_BASE + 0x040u))
#define MAT_A_DATA (*MAT_A_DATA_REG)
#define MAT_B_DATA (*MAT_B_DATA_REG)
#define MAT_AB_CTRL ACCEL_REG32(ACCEL_BASE + 0x080u)

// control_unit (PADDR[9:8] == 01)
#define REG_CTRL ACCEL_REG32(ACCEL_BASE + 0x100u)
#define REG_STATUS ACCEL_REG32(ACCEL_BASE + 0x104u)
#define REG_M_DIM ACCEL_REG32(ACCEL_BASE + 0x108u)
#define REG_N_DIM ACCEL_REG32(ACCEL_BASE + 0x10Cu)
#define REG_INT_EN ACCEL_REG32(ACCEL_BASE + 0x110u)
#define REG_INT_STAT ACCEL_REG32(ACCEL_BASE + 0x114u)
#define REG_K_DIM ACCEL_REG32(ACCEL_BASE + 0x118u)
#define REG_BUILD_INFO ACCEL_REG32(ACCEL_BASE + 0x11Cu)
#define REG_HW_STATUS ACCEL_REG32(ACCEL_BASE + 0x120u)
#define REG_PERF_CTRL ACCEL_REG32(ACCEL_BASE + 0x124u)
#define REG_PERF_CYCLES ACCEL_REG32(ACCEL_BASE + 0x128u)
#define REG_PERF_APB_WRITES ACCEL_REG32(ACCEL_BASE + 0x12Cu)
#define REG_PERF_APB_READS ACCEL_REG32(ACCEL_BASE + 0x130u)
#define REG_PERF_IN_STALLS ACCEL_REG32(ACCEL_BASE + 0x134u)
#define REG_PERF_OUT_STALLS ACCEL_REG32(ACCEL_BASE + 0x138u)

// matrix_buffer_c (PADDR[9:8] == 10)
#define MAT_C_DATA ACCEL_REG32(ACCEL_BASE + 0x200u)
#define MAT_C_CTRL ACCEL_REG32(ACCEL_BASE + 0x280u)

// Control / status bit fields.
#define CTRL_START_BIT (1u << 0)
#define CTRL_SOFTRST_BIT (1u << 1)
#define STATUS_BUSY_BIT (1u << 0)
#define STATUS_DONE_BIT (1u << 1)
#define MAT_CTRL_RESET_BIT (1u << 0)
#define PERF_CLEAR_BIT (1u << 0)
#define HW_STATUS_OUT_STALL_SEEN_BIT (1u << 2)
#define HW_STATUS_COUNTER_OVERFLOW_BIT (1u << 3)

// matrix_buffer_ab MAT_AB_CTRL double-buffering bits (docs/interface/matrix_buffer_a_b_if.md).
#define MAT_AB_CTRL_APB_BANK_BIT (1u << 3)  /* APB write bank select */
#define MAT_AB_CTRL_SYS_BANK_BIT (1u << 4)  /* streaming-read bank select */
#define MAT_AB_CTRL_REUSE_B_BIT (1u << 5)   /* reuse-B flag (selected bank) */

// matrix_buffer_c MAT_C_CTRL double-buffering bits (docs/interface/matrix_buffer_c_if.md).
#define MAT_C_CTRL_APB_BANK_BIT (1u << 3)   /* APB read bank select */
#define MAT_C_CTRL_CAP_BANK_BIT (1u << 4)   /* capture bank select */

#endif // __ACCEL_REGS_H__