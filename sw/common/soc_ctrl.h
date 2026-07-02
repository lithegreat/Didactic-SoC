/*
 * Name: soc_ctrl
 * Contributor(S):
 *    - Matti Käyrä (matti.kayra@tuni.fi)
 * Description:
 *    - helper functions to control didcatic soc
 *    - 
 * Notes:
 *    - addresses are to be moved to common mem map header
 */

#ifndef __SOC_CTRL_H__
#define __SOC_CTRL_H__

#include <stdint.h>

#define CTRL_BASE 0x01400000

//  note: 0x0 offset controls cpu fetch enable, it is used to disable cpu.
#define RST_OFFSET      0x4
#define SS_IRQ_EN_OFFSET 0x10
#define SS_CLK_EN_OFFSET 0x14
#define PMOD_OFFSET     0x24

#define RST_CTRL  *( volatile uint32_t* )(CTRL_BASE+RST_OFFSET)
#define IRQ_EN_CTRL  *( volatile uint32_t* )(CTRL_BASE+SS_IRQ_EN_OFFSET)
#define CLK_EN_CTRL  *( volatile uint32_t* )(CTRL_BASE+SS_CLK_EN_OFFSET)
#define PMOD_CTRL *( volatile uint32_t* )(CTRL_BASE+PMOD_OFFSET)

void ss_init(const uint32_t target_ss){
  // init: clk enable
  volatile uint32_t mask = CLK_EN_CTRL;
  //     old value | target ss bit 
  CLK_EN_CTRL = (mask | 1u<<target_ss );
  // init: reset
  mask = RST_CTRL;
  //     old value | target ss bit | icn reset
  RST_CTRL = (mask | 2u<<target_ss | 1u);
  // init: irq enable
  mask = IRQ_EN_CTRL;
  //     old value | target ss bit 
  IRQ_EN_CTRL = (mask | 1u<<target_ss );
}

void ss_reset(const uint32_t target_ss){
  // reset: reset + clock disabled + irq disabled
  volatile uint32_t mask = 0;

  mask = IRQ_EN_CTRL;
  IRQ_EN_CTRL = (mask & ~(1u<<target_ss));
  mask = RST_CTRL;
  RST_CTRL = mask & ~(2u<<target_ss);
  mask = CLK_EN_CTRL;
  CLK_EN_CTRL = (mask & ~(1u<<target_ss));
}

void pmod_target(const uint32_t target_ss){
  // indexing: ss numbers. all other values route gpios from sysctrl
  PMOD_CTRL = target_ss;
}

#endif