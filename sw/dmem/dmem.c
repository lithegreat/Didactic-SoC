/*
 * Name: dmem.c
 * Contributor(s):
 *    - Paul Genssler (paul.genssler@tum.de)
 * Description:
 *    - tests read/write to dmem
 * Notes:
 */

#include <stdint.h>
#include "soc_ctrl.h"

#define DMEM_ADDR 0x01100000

#define DMEM_SIZE (32 * 1024 * 4) // 32 k * 4 B = 128 kB

volatile unsigned int test = 0xDEADBEEF;

int main() {

  // test if data was loaded correctly through JTAG
  int errors = 0;
  if (test != 0xDEADBEEF) {
    errors++;
  }

  // test dmem read/write
  for (int i = 0; i < DMEM_SIZE; i += 4) {
    *(volatile unsigned int*)(DMEM_ADDR + i) = i;
  }
  for (int i = 0; i < DMEM_SIZE; i += 4) {
    if (*(volatile unsigned int*)(DMEM_ADDR + i) != i) {
      errors++;
    }
  }

  if (errors > 0) {
    *(volatile unsigned int*)(DMEM_ADDR) = errors;
  } else {
    *(volatile unsigned int*)(DMEM_ADDR) = -1;
  }
  
  return errors;
}