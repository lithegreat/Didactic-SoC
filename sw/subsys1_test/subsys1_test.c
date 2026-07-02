
/*
 * Name: ss1 test
 * Contributor(s):
 *    - Matti Käyrä (matti.kayra@tuni.fi)
 * Description:
 *    - test program for subsystem 1
 * Notes:
 */
#include "soc_ctrl.h"
#include "mmio.h"

int main(){
  
  int errors=0;
  //example how to use a ss 1
  ss_init(1);
  // create a pointer to the first memory address of subsystem 0 
  volatile uint32_t* temp_0 = ( volatile uint32_t* ) 0x01510000;
  // this is basic read operation
  uint32_t value = *temp_0;
  // this is basic write operation
  *temp_0 = 0xFF;
  // check if value updated
  if (*temp_0 != 0xFF){
    errors++;
  }

  // simpler code, functions defined in mmio.h
  uint32_t reg_addr = 0x01510000;
  value = read_u32(reg_addr);
  write_u32(reg_addr, value + 1);

  return errors;

}