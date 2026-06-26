/*
 * Project: Edu4chip
 * Description: 
 *   - Didactic linkerscript (Customized for benchmark testcase to reduce STACK_SIZE)
 *   - Adapted from SoC-HUB work
 * Contributors:
 *   - Antti Nurmi        (antti.nurmi@tuni.fi)
 *   - Henri Lunnikivi    (henri.lunnikivi@tuni.fi)
 *   - Abdelkadir Chantar (abdelkadir.chantar@tuni.fi)
 *   - Abdesattar Kalache (abdesattar.kalache@tuni.fi)
 *   - Matti Käyrä        (matti.kayra@tuni.fi)
 */

OUTPUT_ARCH(riscv)
SEARCH_DIR(.)
__DYNAMIC = 0;

MEMORY
{
  IMEM (rx ) : ORIGIN = 0x01000000, LENGTH = 0x4000
  DMEM (rwx) : ORIGIN = 0x01010000, LENGTH = 0x4000
}

STACK_SIZE = 0x400; 

SECTIONS
{
  .text : ALIGN(4)
  {
    KEEP(*(.vectors .vectors.*))
    _stext = .;
    *(.text*)
    _etext = .;
    *(.rodata*)
  } > IMEM

  .data : ALIGN(4)
  {
    *(.data*);
  } > DMEM

  .sdata : ALIGN(4)
  {
    *(.sdata*);
  } > DMEM

  .bss (NOLOAD) :
  {
    *(.bss*)
    *(COMMON)
  } > DMEM
 
  .stack (NOLOAD) : 
  {
    . = ALIGN(4);
    stack = . + STACK_SIZE;
  } > DMEM

  _end = . ;
}
