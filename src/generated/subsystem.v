//-----------------------------------------------------------------------------
// File          : subsystem.v
// Creation date : 11.05.2026
// Creation time : 19:23:35
// Description   : 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:subsystem:subsystem:1.0
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/subsystem/submodule/1.0/submodule.xml
//-----------------------------------------------------------------------------

module subsystem #(
    parameter                              NUM_GPIO         = 16,
    parameter                              APB_AW           = 16,
    parameter                              APB_DW           = 32
) (
    // Interface: APB
    input                [APB_AW-1:0]   PADDR,
    input                               PENABLE,
    input                               PSEL,
    input                [APB_DW-1:0]   PWDATA,
    input                               PWRITE,
    output               [APB_DW-1:0]   PRDATA,
    output                              PREADY,
    output                              PSLVERR,

    // Interface: Clock
    input                               clk,

    // Interface: IRQ
    output logic                        irq,

    // Interface: pmod_gpio
    input                [NUM_GPIO-1:0] pmod_gpi,
    output               [NUM_GPIO-1:0] pmod_gpio_oe,
    output               [NUM_GPIO-1:0] pmod_gpo,

    // These ports are not in any interface
    input                               irq_en,
    input                               reset_n
);

// WARNING: EVERYTHING ON AND ABOVE THIS LINE MAY BE OVERWRITTEN BY KACTUS2!!!

    // Migration to new Didactic-SoC (2026):
    //   * clk_in -> clk         (new SoC port name; directly connected)
    //   * reset_int -> reset_n  (SoC now provides active-low; invert for accel)
    //   * irq_en_X -> irq_en    (slot-index suffix removed)
    //   * irq_X -> irq          (slot-index suffix removed)
    //   * ss_ctrl_X removed     (tied to 0 internally)
    //   * PADDR 32->16 bits     (SoC wrapper already strips upper index bits;
    //                            accelerator uses [9:0], so pass all 16 bits)
    //
    // Physical systolic-array dimension (M = N = K). Override at synthesis
    // time with +define+ACCEL_DIM=8 (e.g. `ACCEL_DIM=8 make all_xilinx`) to
    // fit smaller FPGAs; defaults to 16 to match the standalone testbench.
`ifndef ACCEL_DIM
  `define ACCEL_DIM 16
`endif

    // Element bit-width. INT8 is the baseline; override at compile time with
    // +define+ACCEL_DATA_W=16 for a wider datapath.
`ifndef ACCEL_DATA_W
  `define ACCEL_DATA_W 8
`endif

    accelerator_top #(
        .DATA_W (`ACCEL_DATA_W),
        .M      (`ACCEL_DIM),
        .N      (`ACCEL_DIM),
        .K      (`ACCEL_DIM)
    ) i_accelerator_top (
        .clk_in    (clk),
        .reset_int (~reset_n),
        .PADDR     (PADDR[9:0]),
        .PSEL      (PSEL),
        .PENABLE   (PENABLE),
        .PWRITE    (PWRITE),
        .PWDATA    (PWDATA),
        .PRDATA    (PRDATA),
        .PREADY    (PREADY),
        .PSLVERR   (PSLVERR),
        .irq_en_4  (irq_en),
        .ss_ctrl_4 (8'b0),
        .irq_4     (irq)
    );

    assign pmod_gpio_oe = '0;
    assign pmod_gpo = '0;

endmodule
