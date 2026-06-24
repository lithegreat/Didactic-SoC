#ifndef __ACCEL_GEMM_DATA_H__
#define __ACCEL_GEMM_DATA_H__

#ifndef ACC_DIM
#define ACC_DIM 16
#endif

#if ACC_DIM == 8
#include "accel_gemm_data_8x8.h"
#elif ACC_DIM == 16
#include "accel_gemm_data_16x16.h"
#else
#error "Unsupported ACC_DIM value"
#endif

#endif /* __ACCEL_GEMM_DATA_H__ */
