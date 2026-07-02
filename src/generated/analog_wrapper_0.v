//-----------------------------------------------------------------------------
// File          : analog_wrapper_0.v
// Creation date : 15.05.2026
// Creation time : 10:28:33
// Description   : 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:subsystem.wrapper:analog_wrapper:1.0
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/subsystem.wrapper/analog_wrapper/1.0/analog_wrapper.1.0.xml
//-----------------------------------------------------------------------------

module analog_wrapper_0 #(
    parameter                              APB_DW           = 32,
    parameter                              APB_AW           = 32,
    parameter                              NUM_GPIO         = 16
) (
    // Interface: APB
    input  logic         [31:0]         PADDR,
    input  logic                        PENABLE,
    input  logic                        PSEL,
    input  logic         [3:0]          PSTRB,
    input  logic         [31:0]         PWDATA,
    input  logic                        PWRITE,
    output logic         [31:0]         PRDATA,
    output logic                        PREADY,
    output logic                        PSLVERR,

    // Interface: Clock
    input  logic                        clk_in,

    // Interface: IRQ
    output logic                        irq,

    // Interface: pmod_gpio
    input  logic         [15:0]         pmod_gpi,
    output logic         [15:0]         pmod_gpio_oe,
    output logic         [15:0]         pmod_gpo,

    // These ports are not in any interface
    input  logic                        clk_en,
    input  logic                        irq_en,
    input  logic                        reset_n
);

    // TOP_ISAR_inst_pmod_gpio_to_pmod_gpio wires:
    wire [15:0] TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi;
    wire [15:0] TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpio_oe;
    wire [15:0] TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpo;

    // TOP_ISAR_inst port wires:
    wire [3:0] TOP_ISAR_inst_Csel;
    wire [7:4] TOP_ISAR_inst_Diff;
    wire [14:8] TOP_ISAR_inst_Dummy;
    wire       TOP_ISAR_inst_ESD1;

    // Assignments for the ports of the encompassing component:
    assign PRDATA = 'h0;
    assign PREADY = 1'b1;
    assign PSLVERR = 1'b0;
    assign irq = 1'b0;
    assign TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi = pmod_gpi;
    assign pmod_gpio_oe = 'h0;
    assign pmod_gpo = 'h0;


    // TOP_ISAR_inst assignments:
    assign TOP_ISAR_inst_Csel = TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi[3:0];
    assign TOP_ISAR_inst_Diff = TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi[7:4];
    assign TOP_ISAR_inst_Dummy = TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi[14:8];
    assign TOP_ISAR_inst_ESD1 = TOP_ISAR_inst_pmod_gpio_to_pmod_gpio_gpi[15];

    // IP-XACT VLNV: tuni.fi:subsystem:TOPCELL_ISAR_with_padframe:1.0
    TOPCELL_ISAR_with_padframe TOP_ISAR_inst(
        // Interface: pmod_gpio
        .Csel                (TOP_ISAR_inst_Csel),
        .Diff                (TOP_ISAR_inst_Diff),
        .Dummy               (TOP_ISAR_inst_Dummy),
        .ESD1                (TOP_ISAR_inst_ESD1));


endmodule
