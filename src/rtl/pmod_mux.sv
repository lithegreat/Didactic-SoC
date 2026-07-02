//-----------------------------------------------------------------------------
// File          : pmod_mux.v
// Creation date : 08.05.2026
// Creation time : 13:54:06
// Description   : 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:ip:pmod_mux:1.1
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/ip/pmod_mux/1.0/pmod_mux.1.1.xml
//-----------------------------------------------------------------------------

module pmod_mux #(
    parameter                              NUM_SS           = 8,    // number of subsystems on top level. TODO: combine ss vectors and make this even
    // more generic
    parameter                              IOCELL_CFG_W     = 5,    // control bus width for each individual IO cell
    parameter                              IOCELL_COUNT     = 26,    // number of controllable cells
    parameter                              NUM_GPIO         = 8    // number of subsystems that can control gpio on top level.
) (
    // Interface: cell_cfg_from_core
    input  logic         [IOCELL_COUNT*IOCELL_CFG_W-1:0] cell_cfg_from_core,

    // Interface: cell_cfg_to_io
    output logic         [IOCELL_COUNT*IOCELL_CFG_W-1:0] cell_cfg_to_io,

    // Interface: gpio_core
    input  logic         [NUM_GPIO-1:0] gpio_from_core,
    output logic         [NUM_GPIO-1:0] gpio_to_core,

    // Interface: gpio_io
    input  logic         [NUM_GPIO-1:0] gpio_from_io,
    output logic         [NUM_GPIO-1:0] gpio_to_io,

    // Interface: pmod_sel
    input  logic         [7:0]          pmod_sel,

    // Interface: slot0_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot0_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot0_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot0_pmod_gpi,

    // Interface: slot1_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot1_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot1_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot1_pmod_gpi,

    // Interface: slot2_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot2_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot2_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot2_pmod_gpi,

    // Interface: slot3_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot3_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot3_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot3_pmod_gpi,

    // Interface: slot4_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot4_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot4_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot4_pmod_gpi,

    // Interface: slot5_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot5_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot5_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot5_pmod_gpi,

    // Interface: slot6_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot6_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot6_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot6_pmod_gpi,

    // Interface: slot7_pmod_gpio
    input  logic         [NUM_GPIO-1:0] slot7_pmod_gpio_oe,
    input  logic         [NUM_GPIO-1:0] slot7_pmod_gpo,
    output logic         [NUM_GPIO-1:0] slot7_pmod_gpi
);

// WARNING: EVERYTHING ON AND ABOVE THIS LINE MAY BE OVERWRITTEN BY KACTUS2!!!


  // always direct gpi to controller core
  // disable inputs from subsystems not in use.
  assign gpio_to_core = gpio_from_io;

  logic [NUM_GPIO-1:0] pmod_gpio_oe;

  always_comb mux_process : begin
    slot0_pmod_gpi = 'h0;
    slot1_pmod_gpi = 'h0;
    slot2_pmod_gpi = 'h0;
    slot3_pmod_gpi = 'h0;
    slot4_pmod_gpi = 'h0;
    slot5_pmod_gpi = 'h0;
    slot6_pmod_gpi = 'h0;
    slot7_pmod_gpi = 'h0;
    
    unique case(pmod_sel)
      0: begin
        gpio_to_io = slot0_pmod_gpo;
        pmod_gpio_oe = slot0_pmod_gpio_oe;
        slot0_pmod_gpi = gpio_from_io;
      end
      1: begin
        gpio_to_io = slot1_pmod_gpo;
        pmod_gpio_oe = slot1_pmod_gpio_oe;
        slot1_pmod_gpi = gpio_from_io;
      end
      2: begin
        gpio_to_io = slot2_pmod_gpo;
        pmod_gpio_oe = slot2_pmod_gpio_oe;
        slot2_pmod_gpi = gpio_from_io;
      end
      3: begin
        gpio_to_io = slot3_pmod_gpo;
        pmod_gpio_oe = slot3_pmod_gpio_oe;
        slot3_pmod_gpi = gpio_from_io;
      end
      4: begin
        gpio_to_io = slot4_pmod_gpo;
        pmod_gpio_oe = slot4_pmod_gpio_oe;
        slot4_pmod_gpi = gpio_from_io;
      end
      5: begin
        gpio_to_io = slot5_pmod_gpo;
        pmod_gpio_oe = slot5_pmod_gpio_oe;
        slot5_pmod_gpi = gpio_from_io;
      end
      6: begin
        gpio_to_io = slot6_pmod_gpo;
        pmod_gpio_oe = slot6_pmod_gpio_oe;
        slot6_pmod_gpi = gpio_from_io;
      end
      7: begin
        gpio_to_io = slot7_pmod_gpo;
        pmod_gpio_oe = slot7_pmod_gpio_oe;
        slot7_pmod_gpi = gpio_from_io;
      end
      default: begin
        gpio_to_io = gpio_from_core;
        for(int i = 0; i < NUM_GPIO; i++) begin
          pmod_gpio_oe[i] = cell_cfg_from_core[(i+IOCELL_COUNT-NUM_GPIO)*IOCELL_CFG_W];
        end
      end
    endcase
  end
  
  always_comb io_cfg_process : begin
    // connect all config bits by default
    cell_cfg_to_io = cell_cfg_from_core;
    for(int i = 0; i < NUM_GPIO; i++) begin
      cell_cfg_to_io[(i+IOCELL_COUNT-NUM_GPIO)*IOCELL_CFG_W] = pmod_gpio_oe[i];
    end
  end


endmodule
