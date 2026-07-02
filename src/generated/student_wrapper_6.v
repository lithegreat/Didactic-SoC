//-----------------------------------------------------------------------------
// File          : student_wrapper_6.v
// Creation date : 16.05.2026
// Creation time : 00:47:47
// Description   : 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:subsystem.wrapper:student_wrapper:1.0
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/subsystem.wrapper/student_wrapper/1.0/student_wrapper.1.0.xml
//-----------------------------------------------------------------------------

module student_wrapper_6 #(
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

    // i_subsystem_APB_to_APB wires:
    wire [31:0] i_subsystem_APB_to_APB_PADDR;
    wire       i_subsystem_APB_to_APB_PENABLE;
    wire [31:0] i_subsystem_APB_to_APB_PRDATA;
    wire       i_subsystem_APB_to_APB_PREADY;
    wire       i_subsystem_APB_to_APB_PSEL;
    wire       i_subsystem_APB_to_APB_PSLVERR;
    wire [3:0] i_subsystem_APB_to_APB_PSTRB;
    wire [31:0] i_subsystem_APB_to_APB_PWDATA;
    wire       i_subsystem_APB_to_APB_PWRITE;
    // i_subsystem_pmod_gpio_to_pmod_gpio wires:
    wire [15:0] i_subsystem_pmod_gpio_to_pmod_gpio_gpi;
    wire [15:0] i_subsystem_pmod_gpio_to_pmod_gpio_gpio_oe;
    wire [15:0] i_subsystem_pmod_gpio_to_pmod_gpio_gpo;
    // i_clk_gate_clk_i_to_Clock wires:
    wire       i_clk_gate_clk_i_to_Clock_clk;
    // i_clk_gate_clk_o_to_i_subsystem_Clock wires:
    wire       i_clk_gate_clk_o_to_i_subsystem_Clock_clk;

    // Ad-hoc wires:
    wire       i_subsystem_reset_n_to_reset_n;
    wire       i_clk_gate_en_to_clk_en;
    wire       i_subsystem_irq_to_irq_mask_b;
    wire       irq_mask_a_to_irq_en;
    wire       i_subsystem_irq_en_to_irq_en;
    wire       irq_mask_c_to_irq;

    // i_clk_gate port wires:
    wire       i_clk_gate_clk_i;
    wire       i_clk_gate_clk_o;
    wire       i_clk_gate_en_i;
    // i_subsystem port wires:
    wire [15:0] i_subsystem_PADDR;
    wire       i_subsystem_PENABLE;
    wire [31:0] i_subsystem_PRDATA;
    wire       i_subsystem_PREADY;
    wire       i_subsystem_PSEL;
    wire       i_subsystem_PSLVERR;
    wire [31:0] i_subsystem_PWDATA;
    wire       i_subsystem_PWRITE;
    wire       i_subsystem_clk;
    wire       i_subsystem_irq;
    wire       i_subsystem_irq_en;
    wire [15:0] i_subsystem_pmod_gpi;
    wire [15:0] i_subsystem_pmod_gpio_oe;
    wire [15:0] i_subsystem_pmod_gpo;
    wire       i_subsystem_reset_n;
    // irq_mask port wires:
    wire       irq_mask_a;
    wire       irq_mask_b;
    wire       irq_mask_c;

    // Assignments for the ports of the encompassing component:
    assign i_subsystem_APB_to_APB_PADDR = PADDR;
    assign i_subsystem_APB_to_APB_PENABLE = PENABLE;
    assign PRDATA = i_subsystem_APB_to_APB_PRDATA;
    assign PREADY = i_subsystem_APB_to_APB_PREADY;
    assign i_subsystem_APB_to_APB_PSEL = PSEL;
    assign PSLVERR = i_subsystem_APB_to_APB_PSLVERR;
    assign i_subsystem_APB_to_APB_PWDATA = PWDATA;
    assign i_subsystem_APB_to_APB_PWRITE = PWRITE;
    assign i_clk_gate_en_to_clk_en = clk_en;
    assign i_clk_gate_clk_i_to_Clock_clk = clk_in;
    assign irq = irq_mask_c_to_irq;
    assign i_subsystem_irq_en_to_irq_en = irq_en;
    assign irq_mask_a_to_irq_en = irq_en;
    assign i_subsystem_pmod_gpio_to_pmod_gpio_gpi = pmod_gpi;
    assign pmod_gpio_oe = i_subsystem_pmod_gpio_to_pmod_gpio_gpio_oe;
    assign pmod_gpo = i_subsystem_pmod_gpio_to_pmod_gpio_gpo;
    assign i_subsystem_reset_n_to_reset_n = reset_n;


    // i_clk_gate assignments:
    assign i_clk_gate_clk_i = i_clk_gate_clk_i_to_Clock_clk;
    assign i_clk_gate_clk_o_to_i_subsystem_Clock_clk = i_clk_gate_clk_o;
    assign i_clk_gate_en_i = i_clk_gate_en_to_clk_en;
    // i_subsystem assignments:
    assign i_subsystem_PADDR = i_subsystem_APB_to_APB_PADDR[15:0];
    assign i_subsystem_PENABLE = i_subsystem_APB_to_APB_PENABLE;
    assign i_subsystem_APB_to_APB_PRDATA = i_subsystem_PRDATA;
    assign i_subsystem_APB_to_APB_PREADY = i_subsystem_PREADY;
    assign i_subsystem_PSEL = i_subsystem_APB_to_APB_PSEL;
    assign i_subsystem_APB_to_APB_PSLVERR = i_subsystem_PSLVERR;
    assign i_subsystem_PWDATA = i_subsystem_APB_to_APB_PWDATA;
    assign i_subsystem_PWRITE = i_subsystem_APB_to_APB_PWRITE;
    assign i_subsystem_clk = i_clk_gate_clk_o_to_i_subsystem_Clock_clk;
    assign i_subsystem_irq_to_irq_mask_b = i_subsystem_irq;
    assign i_subsystem_irq_en = i_subsystem_irq_en_to_irq_en;
    assign i_subsystem_pmod_gpi = i_subsystem_pmod_gpio_to_pmod_gpio_gpi;
    assign i_subsystem_pmod_gpio_to_pmod_gpio_gpio_oe = i_subsystem_pmod_gpio_oe;
    assign i_subsystem_pmod_gpio_to_pmod_gpio_gpo = i_subsystem_pmod_gpo;
    assign i_subsystem_reset_n = i_subsystem_reset_n_to_reset_n;
    // irq_mask assignments:
    assign irq_mask_a = irq_mask_a_to_irq_en;
    assign irq_mask_b = i_subsystem_irq_to_irq_mask_b;
    assign irq_mask_c_to_irq = irq_mask_c;

    // IP-XACT VLNV: tuni.fi:tech:tc_clk_gating:1.0
    tc_clk_gating i_clk_gate(
        // Interface: clk_i
        .clk_i               (i_clk_gate_clk_i),
        // Interface: clk_o
        .clk_o               (i_clk_gate_clk_o),
        // These ports are not in any interface
        .en_i                (i_clk_gate_en_i),
        .test_en_i         (1'b0));

    // IP-XACT VLNV: tuni.fi:subsystem:subsystem:1.0
    subsystem i_subsystem_6(
        // Interface: APB
        .PADDR               (i_subsystem_PADDR),
        .PENABLE             (i_subsystem_PENABLE),
        .PSEL                (i_subsystem_PSEL),
        .PWDATA              (i_subsystem_PWDATA),
        .PWRITE              (i_subsystem_PWRITE),
        .PRDATA              (i_subsystem_PRDATA),
        .PREADY              (i_subsystem_PREADY),
        .PSLVERR             (i_subsystem_PSLVERR),
        // Interface: Clock
        .clk                 (i_subsystem_clk),
        // Interface: IRQ
        .irq                 (i_subsystem_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (i_subsystem_pmod_gpi),
        .pmod_gpio_oe        (i_subsystem_pmod_gpio_oe),
        .pmod_gpo            (i_subsystem_pmod_gpo),
        // These ports are not in any interface
        .irq_en              (i_subsystem_irq_en),
        .reset_n             (i_subsystem_reset_n));

    // IP-XACT VLNV: tuni.fi:tech:generic_and:1.0
    generic_and irq_mask(
        // These ports are not in any interface
        .a                   (irq_mask_a),
        .b                   (irq_mask_b),
        .c                   (irq_mask_c));


endmodule
