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

endmodule
