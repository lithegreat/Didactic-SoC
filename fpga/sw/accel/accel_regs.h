#ifndef __ACCEL_REGS_H__
#define __ACCEL_REGS_H__

#include <stdint.h>

// TUM subsystem slot index and accelerator APB base address.
#define ACCEL_SS 1
#define ACCEL_BASE 0x01051000u

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

#endif // __ACCEL_REGS_H__