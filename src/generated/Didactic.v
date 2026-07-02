//-----------------------------------------------------------------------------
// File          : Didactic.v
// Creation date : 15.05.2026
// Creation time : 10:28:33
// Description   : Edu4Chip top level example SoC.
//                 
//                 Spec: 
//                 * RiscV core
//                 * Extendable
//                 * UART/SPI/GPIO peripherals
//                 * programmable via JTAG
//                 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:soc:Didactic:1.2
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/soc/Didactic/1.2/Didactic.1.2.xml
//-----------------------------------------------------------------------------

module Didactic #(
    parameter                              AW               = 32,    // Global SoC address width
    parameter                              DW               = 32,    // Global SoC data width
    parameter                              SS_CTRL_W        = 8,    // SoC SS control width
    parameter                              NUM_GPIO         = 16,    // SoC GPIO Cell count. Default 16.
    parameter                              IOCELL_CFG_W     = 7,    // Tech cell control width.
    parameter                              IOCELL_COUNT     = 32,    // number of configurable io cells in design
    parameter                              NUM_SS           = 8    // number of student systems present in top level.
) (
    // Interface: Clock
    input  wire                         clk_in,

    // Interface: GPIO
    inout  wire          [15:0]         gpio,

    // Interface: JTAG
    input  wire                         jtag_tck,
    input  wire                         jtag_tdi,
    input  wire                         jtag_tms,
    input  wire                         jtag_trst,
    output wire                         jtag_tdo,

    // Interface: Reset_n
    input  wire                         reset_n,

    // Interface: SPI
    output wire          [1:0]          spi_csn,
    output wire                         spi_sck,
    inout  wire          [3:0]          spi_data,

    // Interface: UART
    input  wire                         uart_rx,
    output wire                         uart_tx
);

    // i_system_control_UART_to_UART wires:
    wire       i_system_control_UART_to_UART_uart_rx;
    wire       i_system_control_UART_to_UART_uart_tx;
    // i_system_control_SPI_to_SPI wires:
    wire [1:0] i_system_control_SPI_to_SPI_csn;
    wire       i_system_control_SPI_to_SPI_sck;
    // i_system_control_GPIO_to_GPIO wires:
    // i_system_control_JTAG_to_JTAG wires:
    wire       i_system_control_JTAG_to_JTAG_tck;
    wire       i_system_control_JTAG_to_JTAG_tdi;
    wire       i_system_control_JTAG_to_JTAG_tdo;
    wire       i_system_control_JTAG_to_JTAG_tms;
    wire       i_system_control_JTAG_to_JTAG_trst;
    // i_system_control_OBI_to_i_obi_icn_ss_OBI wires:
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_achk;
    wire [31:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_addr;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_aid;
    wire [5:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_atop;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_auser;
    wire [3:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_be;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_dbg;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_err;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_exokay;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_gnt;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_gntpar;
    wire [1:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_memtype;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_mid;
    wire [2:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_prot;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rchk;
    wire [31:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_rdata;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_req;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_reqpar;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rid;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rready;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rreadypar;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_ruser;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalid;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalidpar;
    wire [31:0] i_system_control_OBI_to_i_obi_icn_ss_OBI_wdata;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_we;
    wire       i_system_control_OBI_to_i_obi_icn_ss_OBI_wuser;
    // i_system_control_Clock_int_to_i_obi_icn_ss_clock wires:
    wire       i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    // i_obi_icn_ss_reset_to_i_system_control_Reset_icn wires:
    wire       i_obi_icn_ss_reset_to_i_system_control_Reset_icn_reset;
    // i_system_control_Clock_to_Clock wires:
    wire       i_system_control_Clock_to_Clock_clock_in;
    // i_obi_icn_ss_apb_1_to_student_wrapper_1_APB wires:
    wire [31:0] i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PADDR;
    wire       i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PRDATA;
    wire       i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PREADY;
    wire       i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSEL;
    wire       i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWDATA;
    wire       i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWRITE;
    // i_obi_icn_ss_apb_2_to_student_wrapper_2_APB wires:
    wire [31:0] i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PADDR;
    wire       i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PRDATA;
    wire       i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PREADY;
    wire       i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSEL;
    wire       i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWDATA;
    wire       i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWRITE;
    // i_obi_icn_ss_apb_3_to_student_wrapper_3_APB wires:
    wire [31:0] i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PADDR;
    wire       i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PRDATA;
    wire       i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PREADY;
    wire       i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSEL;
    wire       i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWDATA;
    wire       i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWRITE;
    // i_obi_icn_ss_apb_4_to_student_wrapper_4_APB wires:
    wire [31:0] i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PADDR;
    wire       i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PRDATA;
    wire       i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PREADY;
    wire       i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSEL;
    wire       i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWDATA;
    wire       i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWRITE;
    // i_obi_icn_ss_apb_5_to_student_wrapper_5_APB wires:
    wire [31:0] i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PADDR;
    wire       i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PRDATA;
    wire       i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PREADY;
    wire       i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSEL;
    wire       i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWDATA;
    wire       i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWRITE;
    // i_obi_icn_ss_apb_6_to_student_wrapper_6_APB wires:
    wire [31:0] i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PADDR;
    wire       i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PRDATA;
    wire       i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PREADY;
    wire       i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSEL;
    wire       i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWDATA;
    wire       i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWRITE;
    // i_obi_icn_ss_apb_7_to_student_wrapper_7_APB wires:
    wire [31:0] i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PADDR;
    wire       i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PRDATA;
    wire       i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PREADY;
    wire       i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSEL;
    wire       i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWDATA;
    wire       i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWRITE;
    // i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio wires:
    wire [15:0] i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpi;
    wire [15:0] i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpo;
    // i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio wires:
    wire [15:0] i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpi;
    wire [15:0] i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpo;
    // i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio wires:
    wire [15:0] i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpi;
    wire [15:0] i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpo;
    // i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio wires:
    wire [15:0] i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpi;
    wire [15:0] i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpo;
    // i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio wires:
    wire [15:0] i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpi;
    wire [15:0] i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpo;
    // i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio wires:
    wire [15:0] i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpi;
    wire [15:0] i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpo;
    // i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio wires:
    wire [15:0] i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpi;
    wire [15:0] i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpo;
    // i_system_control_ICN_SS_Ctrl_to_i_obi_icn_ss_icn_ss_ctrl wires:
    wire [7:0] i_system_control_ICN_SS_Ctrl_to_i_obi_icn_ss_icn_ss_ctrl_clk_ctrl;
    // i_system_control_Reset_to_Reset_n wires:
    wire       i_system_control_Reset_to_Reset_n_reset;
    // i_obi_icn_ss_apb_0_to_analog_wrapper_APB wires:
    wire [31:0] i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PADDR;
    wire       i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PENABLE;
    wire [31:0] i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PRDATA;
    wire       i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PREADY;
    wire       i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSEL;
    wire       i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSLVERR;
    wire [3:0] i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSTRB;
    wire [31:0] i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWDATA;
    wire       i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWRITE;
    // i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio wires:
    wire [15:0] i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpi;
    wire [15:0] i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpio_oe;
    wire [15:0] i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpo;

    // Ad-hoc wires:
    wire       student_wrapper_2_clk_en_to_i_system_control_clk_ctrl;
    wire       student_wrapper_1_clk_en_to_i_system_control_clk_ctrl;
    wire       i_system_control_clk_ctrl_to_student_wrapper_3_clk_en;
    wire       i_system_control_clk_ctrl_to_student_wrapper_4_clk_en;
    wire       i_system_control_clk_ctrl_to_student_wrapper_5_clk_en;
    wire       i_system_control_clk_ctrl_to_student_wrapper_6_clk_en;
    wire       i_system_control_clk_ctrl_to_student_wrapper_7_clk_en;
    wire       student_wrapper_7_reset_to_i_system_control_reset_ss;
    wire       student_wrapper_7_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_6_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_6_reset_to_i_system_control_reset_ss;
    wire       i_system_control_reset_ss_to_student_wrapper_1_reset;
    wire       i_system_control_reset_ss_to_student_wrapper_2_reset;
    wire       i_system_control_reset_ss_to_student_wrapper_3_reset;
    wire       i_system_control_reset_ss_to_student_wrapper_4_reset;
    wire       i_system_control_reset_ss_to_student_wrapper_5_reset;
    wire       student_wrapper_5_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_4_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_3_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_2_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_1_irq_en_to_i_system_control_irq_en;
    wire       student_wrapper_7_irq_to_i_system_control_irq_i;
    wire       student_wrapper_6_irq_to_i_system_control_irq_i;
    wire       student_wrapper_5_irq_to_i_system_control_irq_i;
    wire       student_wrapper_4_irq_to_i_system_control_irq_i;
    wire       student_wrapper_3_irq_to_i_system_control_irq_i;
    wire       student_wrapper_2_irq_to_i_system_control_irq_i;
    wire       student_wrapper_1_irq_to_i_system_control_irq_i;
    wire       analog_wrapper_irq_to_i_system_control_irq_i;
    wire       i_system_control_clk_ctrl_to_analog_wrapper_clk_en;
    wire       i_system_control_reset_ss_to_analog_wrapper_reset_n;
    wire [7:0] i_system_control_irq_en_to_analog_wrapper_irq_en;

    // analog_wrapper port wires:
    wire [31:0] analog_wrapper_PADDR;
    wire       analog_wrapper_PENABLE;
    wire [31:0] analog_wrapper_PRDATA;
    wire       analog_wrapper_PREADY;
    wire       analog_wrapper_PSEL;
    wire       analog_wrapper_PSLVERR;
    wire [3:0] analog_wrapper_PSTRB;
    wire [31:0] analog_wrapper_PWDATA;
    wire       analog_wrapper_PWRITE;
    wire       analog_wrapper_clk_en;
    wire       analog_wrapper_clk_in;
    wire       analog_wrapper_irq;
    wire       analog_wrapper_irq_en;
    wire [15:0] analog_wrapper_pmod_gpi;
    wire [15:0] analog_wrapper_pmod_gpio_oe;
    wire [15:0] analog_wrapper_pmod_gpo;
    wire       analog_wrapper_reset_n;
    // i_obi_icn_ss port wires:
    wire [31:0] i_obi_icn_ss_APB_0_PADDR;
    wire       i_obi_icn_ss_APB_0_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_0_PRDATA;
    wire       i_obi_icn_ss_APB_0_PREADY;
    wire       i_obi_icn_ss_APB_0_PSEL;
    wire       i_obi_icn_ss_APB_0_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_0_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_0_PWDATA;
    wire       i_obi_icn_ss_APB_0_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_1_PADDR;
    wire       i_obi_icn_ss_APB_1_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_1_PRDATA;
    wire       i_obi_icn_ss_APB_1_PREADY;
    wire       i_obi_icn_ss_APB_1_PSEL;
    wire       i_obi_icn_ss_APB_1_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_1_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_1_PWDATA;
    wire       i_obi_icn_ss_APB_1_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_2_PADDR;
    wire       i_obi_icn_ss_APB_2_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_2_PRDATA;
    wire       i_obi_icn_ss_APB_2_PREADY;
    wire       i_obi_icn_ss_APB_2_PSEL;
    wire       i_obi_icn_ss_APB_2_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_2_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_2_PWDATA;
    wire       i_obi_icn_ss_APB_2_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_3_PADDR;
    wire       i_obi_icn_ss_APB_3_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_3_PRDATA;
    wire       i_obi_icn_ss_APB_3_PREADY;
    wire       i_obi_icn_ss_APB_3_PSEL;
    wire       i_obi_icn_ss_APB_3_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_3_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_3_PWDATA;
    wire       i_obi_icn_ss_APB_3_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_4_PADDR;
    wire       i_obi_icn_ss_APB_4_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_4_PRDATA;
    wire       i_obi_icn_ss_APB_4_PREADY;
    wire       i_obi_icn_ss_APB_4_PSEL;
    wire       i_obi_icn_ss_APB_4_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_4_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_4_PWDATA;
    wire       i_obi_icn_ss_APB_4_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_5_PADDR;
    wire       i_obi_icn_ss_APB_5_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_5_PRDATA;
    wire       i_obi_icn_ss_APB_5_PREADY;
    wire       i_obi_icn_ss_APB_5_PSEL;
    wire       i_obi_icn_ss_APB_5_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_5_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_5_PWDATA;
    wire       i_obi_icn_ss_APB_5_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_6_PADDR;
    wire       i_obi_icn_ss_APB_6_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_6_PRDATA;
    wire       i_obi_icn_ss_APB_6_PREADY;
    wire       i_obi_icn_ss_APB_6_PSEL;
    wire       i_obi_icn_ss_APB_6_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_6_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_6_PWDATA;
    wire       i_obi_icn_ss_APB_6_PWRITE;
    wire [31:0] i_obi_icn_ss_APB_7_PADDR;
    wire       i_obi_icn_ss_APB_7_PENABLE;
    wire [31:0] i_obi_icn_ss_APB_7_PRDATA;
    wire       i_obi_icn_ss_APB_7_PREADY;
    wire       i_obi_icn_ss_APB_7_PSEL;
    wire       i_obi_icn_ss_APB_7_PSLVERR;
    wire [3:0] i_obi_icn_ss_APB_7_PSTRB;
    wire [31:0] i_obi_icn_ss_APB_7_PWDATA;
    wire       i_obi_icn_ss_APB_7_PWRITE;
    wire       i_obi_icn_ss_clk;
    wire       i_obi_icn_ss_obi_achk;
    wire [31:0] i_obi_icn_ss_obi_addr;
    wire       i_obi_icn_ss_obi_aid;
    wire [5:0] i_obi_icn_ss_obi_atop;
    wire       i_obi_icn_ss_obi_auser;
    wire [3:0] i_obi_icn_ss_obi_be;
    wire       i_obi_icn_ss_obi_dbg;
    wire       i_obi_icn_ss_obi_err;
    wire       i_obi_icn_ss_obi_exokay;
    wire       i_obi_icn_ss_obi_gnt;
    wire       i_obi_icn_ss_obi_gntpar;
    wire [1:0] i_obi_icn_ss_obi_memtype;
    wire       i_obi_icn_ss_obi_mid;
    wire [2:0] i_obi_icn_ss_obi_prot;
    wire       i_obi_icn_ss_obi_rchk;
    wire [31:0] i_obi_icn_ss_obi_rdata;
    wire       i_obi_icn_ss_obi_req;
    wire       i_obi_icn_ss_obi_reqpar;
    wire       i_obi_icn_ss_obi_rid;
    wire       i_obi_icn_ss_obi_rready;
    wire       i_obi_icn_ss_obi_rreadypar;
    wire       i_obi_icn_ss_obi_ruser;
    wire       i_obi_icn_ss_obi_rvalid;
    wire       i_obi_icn_ss_obi_rvalidpar;
    wire [31:0] i_obi_icn_ss_obi_wdata;
    wire       i_obi_icn_ss_obi_we;
    wire       i_obi_icn_ss_obi_wuser;
    wire       i_obi_icn_ss_reset_n;
    wire [7:0] i_obi_icn_ss_ss_ctrl_icn;
    // i_system_control port wires:
    wire [15:0] i_system_control_analog_pmod_gpi;
    wire [15:0] i_system_control_analog_pmod_gpio_oe;
    wire [15:0] i_system_control_analog_pmod_gpo;
    wire       i_system_control_clk;
    wire [7:0] i_system_control_clk_ctrl;
    wire       i_system_control_clock_in;
    wire [7:0] i_system_control_irq_en;
    wire [7:0] i_system_control_irq_i;
    wire       i_system_control_jtag_tck;
    wire       i_system_control_jtag_tdi;
    wire       i_system_control_jtag_tdo;
    wire       i_system_control_jtag_tms;
    wire       i_system_control_jtag_trst;
    wire       i_system_control_obi_achk;
    wire [31:0] i_system_control_obi_addr;
    wire       i_system_control_obi_aid;
    wire [5:0] i_system_control_obi_atop;
    wire       i_system_control_obi_auser;
    wire [3:0] i_system_control_obi_be;
    wire       i_system_control_obi_dbg;
    wire       i_system_control_obi_err;
    wire       i_system_control_obi_exokay;
    wire       i_system_control_obi_gnt;
    wire       i_system_control_obi_gntpar;
    wire [1:0] i_system_control_obi_memtype;
    wire       i_system_control_obi_mid;
    wire [2:0] i_system_control_obi_prot;
    wire       i_system_control_obi_rchk;
    wire [31:0] i_system_control_obi_rdata;
    wire       i_system_control_obi_req;
    wire       i_system_control_obi_reqpar;
    wire       i_system_control_obi_rid;
    wire       i_system_control_obi_rready;
    wire       i_system_control_obi_rreadypar;
    wire       i_system_control_obi_ruser;
    wire       i_system_control_obi_rvalid;
    wire       i_system_control_obi_rvalidpar;
    wire [31:0] i_system_control_obi_wdata;
    wire       i_system_control_obi_we;
    wire       i_system_control_obi_wuser;
    wire       i_system_control_reset;
    wire       i_system_control_reset_int;
    wire [7:0] i_system_control_reset_ss;
    wire [15:0] i_system_control_slot1_pmod_gpi;
    wire [15:0] i_system_control_slot1_pmod_gpio_oe;
    wire [15:0] i_system_control_slot1_pmod_gpo;
    wire [15:0] i_system_control_slot2_pmod_gpi;
    wire [15:0] i_system_control_slot2_pmod_gpio_oe;
    wire [15:0] i_system_control_slot2_pmod_gpo;
    wire [15:0] i_system_control_slot3_pmod_gpi;
    wire [15:0] i_system_control_slot3_pmod_gpio_oe;
    wire [15:0] i_system_control_slot3_pmod_gpo;
    wire [15:0] i_system_control_slot4_pmod_gpi;
    wire [15:0] i_system_control_slot4_pmod_gpio_oe;
    wire [15:0] i_system_control_slot4_pmod_gpo;
    wire [15:0] i_system_control_slot5_pmod_gpi;
    wire [15:0] i_system_control_slot5_pmod_gpio_oe;
    wire [15:0] i_system_control_slot5_pmod_gpo;
    wire [15:0] i_system_control_slot6_pmod_gpi;
    wire [15:0] i_system_control_slot6_pmod_gpio_oe;
    wire [15:0] i_system_control_slot6_pmod_gpo;
    wire [15:0] i_system_control_slot7_pmod_gpi;
    wire [15:0] i_system_control_slot7_pmod_gpio_oe;
    wire [15:0] i_system_control_slot7_pmod_gpo;
    wire [1:0] i_system_control_spi_csn;
    wire       i_system_control_spi_sck;
    wire [7:0] i_system_control_ss_ctrl_icn;
    wire       i_system_control_uart_rx;
    wire       i_system_control_uart_tx;
    // student_wrapper_1 port wires:
    wire [31:0] student_wrapper_1_PADDR;
    wire       student_wrapper_1_PENABLE;
    wire [31:0] student_wrapper_1_PRDATA;
    wire       student_wrapper_1_PREADY;
    wire       student_wrapper_1_PSEL;
    wire       student_wrapper_1_PSLVERR;
    wire [3:0] student_wrapper_1_PSTRB;
    wire [31:0] student_wrapper_1_PWDATA;
    wire       student_wrapper_1_PWRITE;
    wire       student_wrapper_1_clk_en;
    wire       student_wrapper_1_clk_in;
    wire       student_wrapper_1_irq;
    wire       student_wrapper_1_irq_en;
    wire [15:0] student_wrapper_1_pmod_gpi;
    wire [15:0] student_wrapper_1_pmod_gpio_oe;
    wire [15:0] student_wrapper_1_pmod_gpo;
    wire       student_wrapper_1_reset_n;
    // student_wrapper_2 port wires:
    wire [31:0] student_wrapper_2_PADDR;
    wire       student_wrapper_2_PENABLE;
    wire [31:0] student_wrapper_2_PRDATA;
    wire       student_wrapper_2_PREADY;
    wire       student_wrapper_2_PSEL;
    wire       student_wrapper_2_PSLVERR;
    wire [3:0] student_wrapper_2_PSTRB;
    wire [31:0] student_wrapper_2_PWDATA;
    wire       student_wrapper_2_PWRITE;
    wire       student_wrapper_2_clk_en;
    wire       student_wrapper_2_clk_in;
    wire       student_wrapper_2_irq;
    wire       student_wrapper_2_irq_en;
    wire [15:0] student_wrapper_2_pmod_gpi;
    wire [15:0] student_wrapper_2_pmod_gpio_oe;
    wire [15:0] student_wrapper_2_pmod_gpo;
    wire       student_wrapper_2_reset_n;
    // student_wrapper_3 port wires:
    wire [31:0] student_wrapper_3_PADDR;
    wire       student_wrapper_3_PENABLE;
    wire [31:0] student_wrapper_3_PRDATA;
    wire       student_wrapper_3_PREADY;
    wire       student_wrapper_3_PSEL;
    wire       student_wrapper_3_PSLVERR;
    wire [3:0] student_wrapper_3_PSTRB;
    wire [31:0] student_wrapper_3_PWDATA;
    wire       student_wrapper_3_PWRITE;
    wire       student_wrapper_3_clk_en;
    wire       student_wrapper_3_clk_in;
    wire       student_wrapper_3_irq;
    wire       student_wrapper_3_irq_en;
    wire [15:0] student_wrapper_3_pmod_gpi;
    wire [15:0] student_wrapper_3_pmod_gpio_oe;
    wire [15:0] student_wrapper_3_pmod_gpo;
    wire       student_wrapper_3_reset_n;
    // student_wrapper_4 port wires:
    wire [31:0] student_wrapper_4_PADDR;
    wire       student_wrapper_4_PENABLE;
    wire [31:0] student_wrapper_4_PRDATA;
    wire       student_wrapper_4_PREADY;
    wire       student_wrapper_4_PSEL;
    wire       student_wrapper_4_PSLVERR;
    wire [3:0] student_wrapper_4_PSTRB;
    wire [31:0] student_wrapper_4_PWDATA;
    wire       student_wrapper_4_PWRITE;
    wire       student_wrapper_4_clk_en;
    wire       student_wrapper_4_clk_in;
    wire       student_wrapper_4_irq;
    wire       student_wrapper_4_irq_en;
    wire [15:0] student_wrapper_4_pmod_gpi;
    wire [15:0] student_wrapper_4_pmod_gpio_oe;
    wire [15:0] student_wrapper_4_pmod_gpo;
    wire       student_wrapper_4_reset_n;
    // student_wrapper_5 port wires:
    wire [31:0] student_wrapper_5_PADDR;
    wire       student_wrapper_5_PENABLE;
    wire [31:0] student_wrapper_5_PRDATA;
    wire       student_wrapper_5_PREADY;
    wire       student_wrapper_5_PSEL;
    wire       student_wrapper_5_PSLVERR;
    wire [3:0] student_wrapper_5_PSTRB;
    wire [31:0] student_wrapper_5_PWDATA;
    wire       student_wrapper_5_PWRITE;
    wire       student_wrapper_5_clk_en;
    wire       student_wrapper_5_clk_in;
    wire       student_wrapper_5_irq;
    wire       student_wrapper_5_irq_en;
    wire [15:0] student_wrapper_5_pmod_gpi;
    wire [15:0] student_wrapper_5_pmod_gpio_oe;
    wire [15:0] student_wrapper_5_pmod_gpo;
    wire       student_wrapper_5_reset_n;
    // student_wrapper_6 port wires:
    wire [31:0] student_wrapper_6_PADDR;
    wire       student_wrapper_6_PENABLE;
    wire [31:0] student_wrapper_6_PRDATA;
    wire       student_wrapper_6_PREADY;
    wire       student_wrapper_6_PSEL;
    wire       student_wrapper_6_PSLVERR;
    wire [3:0] student_wrapper_6_PSTRB;
    wire [31:0] student_wrapper_6_PWDATA;
    wire       student_wrapper_6_PWRITE;
    wire       student_wrapper_6_clk_en;
    wire       student_wrapper_6_clk_in;
    wire       student_wrapper_6_irq;
    wire       student_wrapper_6_irq_en;
    wire [15:0] student_wrapper_6_pmod_gpi;
    wire [15:0] student_wrapper_6_pmod_gpio_oe;
    wire [15:0] student_wrapper_6_pmod_gpo;
    wire       student_wrapper_6_reset_n;
    // student_wrapper_7 port wires:
    wire [31:0] student_wrapper_7_PADDR;
    wire       student_wrapper_7_PENABLE;
    wire [31:0] student_wrapper_7_PRDATA;
    wire       student_wrapper_7_PREADY;
    wire       student_wrapper_7_PSEL;
    wire       student_wrapper_7_PSLVERR;
    wire [3:0] student_wrapper_7_PSTRB;
    wire [31:0] student_wrapper_7_PWDATA;
    wire       student_wrapper_7_PWRITE;
    wire       student_wrapper_7_clk_en;
    wire       student_wrapper_7_clk_in;
    wire       student_wrapper_7_irq;
    wire       student_wrapper_7_irq_en;
    wire [15:0] student_wrapper_7_pmod_gpi;
    wire [15:0] student_wrapper_7_pmod_gpio_oe;
    wire [15:0] student_wrapper_7_pmod_gpo;
    wire       student_wrapper_7_reset_n;

    // Assignments for the ports of the encompassing component:
    assign i_system_control_Clock_to_Clock_clock_in = clk_in;
    assign i_system_control_JTAG_to_JTAG_tck = jtag_tck;
    assign i_system_control_JTAG_to_JTAG_tdi = jtag_tdi;
    assign jtag_tdo = i_system_control_JTAG_to_JTAG_tdo;
    assign i_system_control_JTAG_to_JTAG_tms = jtag_tms;
    assign i_system_control_JTAG_to_JTAG_trst = jtag_trst;
    assign i_system_control_Reset_to_Reset_n_reset = reset_n;
    assign spi_csn = i_system_control_SPI_to_SPI_csn;
    assign spi_sck = i_system_control_SPI_to_SPI_sck;
    assign i_system_control_UART_to_UART_uart_rx = uart_rx;
    assign uart_tx = i_system_control_UART_to_UART_uart_tx;

    // analog_wrapper assignments:
    assign analog_wrapper_PADDR = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PADDR;
    assign analog_wrapper_PENABLE = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PENABLE;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PRDATA = analog_wrapper_PRDATA;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PREADY = analog_wrapper_PREADY;
    assign analog_wrapper_PSEL = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSEL;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSLVERR = analog_wrapper_PSLVERR;
    assign analog_wrapper_PSTRB = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSTRB;
    assign analog_wrapper_PWDATA = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWDATA;
    assign analog_wrapper_PWRITE = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWRITE;
    assign analog_wrapper_clk_en = i_system_control_clk_ctrl_to_analog_wrapper_clk_en;
    assign analog_wrapper_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign analog_wrapper_irq_to_i_system_control_irq_i = analog_wrapper_irq;
    assign analog_wrapper_irq_en = i_system_control_irq_en_to_analog_wrapper_irq_en[0];
    assign analog_wrapper_pmod_gpi = i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpi;
    assign i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpio_oe = analog_wrapper_pmod_gpio_oe;
    assign i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpo = analog_wrapper_pmod_gpo;
    assign analog_wrapper_reset_n = i_system_control_reset_ss_to_analog_wrapper_reset_n;
    // i_obi_icn_ss assignments:
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PADDR = i_obi_icn_ss_APB_0_PADDR;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PENABLE = i_obi_icn_ss_APB_0_PENABLE;
    assign i_obi_icn_ss_APB_0_PRDATA = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PRDATA;
    assign i_obi_icn_ss_APB_0_PREADY = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PREADY;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSEL = i_obi_icn_ss_APB_0_PSEL;
    assign i_obi_icn_ss_APB_0_PSLVERR = i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSLVERR;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PSTRB = i_obi_icn_ss_APB_0_PSTRB;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWDATA = i_obi_icn_ss_APB_0_PWDATA;
    assign i_obi_icn_ss_apb_0_to_analog_wrapper_APB_PWRITE = i_obi_icn_ss_APB_0_PWRITE;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PADDR = i_obi_icn_ss_APB_1_PADDR;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PENABLE = i_obi_icn_ss_APB_1_PENABLE;
    assign i_obi_icn_ss_APB_1_PRDATA = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PRDATA;
    assign i_obi_icn_ss_APB_1_PREADY = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PREADY;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSEL = i_obi_icn_ss_APB_1_PSEL;
    assign i_obi_icn_ss_APB_1_PSLVERR = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSLVERR;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSTRB = i_obi_icn_ss_APB_1_PSTRB;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWDATA = i_obi_icn_ss_APB_1_PWDATA;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWRITE = i_obi_icn_ss_APB_1_PWRITE;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PADDR = i_obi_icn_ss_APB_2_PADDR;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PENABLE = i_obi_icn_ss_APB_2_PENABLE;
    assign i_obi_icn_ss_APB_2_PRDATA = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PRDATA;
    assign i_obi_icn_ss_APB_2_PREADY = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PREADY;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSEL = i_obi_icn_ss_APB_2_PSEL;
    assign i_obi_icn_ss_APB_2_PSLVERR = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSLVERR;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSTRB = i_obi_icn_ss_APB_2_PSTRB;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWDATA = i_obi_icn_ss_APB_2_PWDATA;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWRITE = i_obi_icn_ss_APB_2_PWRITE;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PADDR = i_obi_icn_ss_APB_3_PADDR;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PENABLE = i_obi_icn_ss_APB_3_PENABLE;
    assign i_obi_icn_ss_APB_3_PRDATA = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PRDATA;
    assign i_obi_icn_ss_APB_3_PREADY = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PREADY;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSEL = i_obi_icn_ss_APB_3_PSEL;
    assign i_obi_icn_ss_APB_3_PSLVERR = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSLVERR;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSTRB = i_obi_icn_ss_APB_3_PSTRB;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWDATA = i_obi_icn_ss_APB_3_PWDATA;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWRITE = i_obi_icn_ss_APB_3_PWRITE;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PADDR = i_obi_icn_ss_APB_4_PADDR;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PENABLE = i_obi_icn_ss_APB_4_PENABLE;
    assign i_obi_icn_ss_APB_4_PRDATA = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PRDATA;
    assign i_obi_icn_ss_APB_4_PREADY = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PREADY;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSEL = i_obi_icn_ss_APB_4_PSEL;
    assign i_obi_icn_ss_APB_4_PSLVERR = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSLVERR;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSTRB = i_obi_icn_ss_APB_4_PSTRB;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWDATA = i_obi_icn_ss_APB_4_PWDATA;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWRITE = i_obi_icn_ss_APB_4_PWRITE;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PADDR = i_obi_icn_ss_APB_5_PADDR;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PENABLE = i_obi_icn_ss_APB_5_PENABLE;
    assign i_obi_icn_ss_APB_5_PRDATA = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PRDATA;
    assign i_obi_icn_ss_APB_5_PREADY = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PREADY;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSEL = i_obi_icn_ss_APB_5_PSEL;
    assign i_obi_icn_ss_APB_5_PSLVERR = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSLVERR;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSTRB = i_obi_icn_ss_APB_5_PSTRB;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWDATA = i_obi_icn_ss_APB_5_PWDATA;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWRITE = i_obi_icn_ss_APB_5_PWRITE;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PADDR = i_obi_icn_ss_APB_6_PADDR;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PENABLE = i_obi_icn_ss_APB_6_PENABLE;
    assign i_obi_icn_ss_APB_6_PRDATA = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PRDATA;
    assign i_obi_icn_ss_APB_6_PREADY = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PREADY;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSEL = i_obi_icn_ss_APB_6_PSEL;
    assign i_obi_icn_ss_APB_6_PSLVERR = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSLVERR;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSTRB = i_obi_icn_ss_APB_6_PSTRB;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWDATA = i_obi_icn_ss_APB_6_PWDATA;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWRITE = i_obi_icn_ss_APB_6_PWRITE;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PADDR = i_obi_icn_ss_APB_7_PADDR;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PENABLE = i_obi_icn_ss_APB_7_PENABLE;
    assign i_obi_icn_ss_APB_7_PRDATA = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PRDATA;
    assign i_obi_icn_ss_APB_7_PREADY = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PREADY;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSEL = i_obi_icn_ss_APB_7_PSEL;
    assign i_obi_icn_ss_APB_7_PSLVERR = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSLVERR;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSTRB = i_obi_icn_ss_APB_7_PSTRB;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWDATA = i_obi_icn_ss_APB_7_PWDATA;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWRITE = i_obi_icn_ss_APB_7_PWRITE;
    assign i_obi_icn_ss_clk = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign i_obi_icn_ss_obi_addr = i_system_control_OBI_to_i_obi_icn_ss_OBI_addr;
    assign i_obi_icn_ss_obi_aid = i_system_control_OBI_to_i_obi_icn_ss_OBI_aid;
    assign i_obi_icn_ss_obi_be = i_system_control_OBI_to_i_obi_icn_ss_OBI_be;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_err = i_obi_icn_ss_obi_err;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_gnt = i_obi_icn_ss_obi_gnt;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_gntpar = i_obi_icn_ss_obi_gntpar;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rdata = i_obi_icn_ss_obi_rdata;
    assign i_obi_icn_ss_obi_req = i_system_control_OBI_to_i_obi_icn_ss_OBI_req;
    assign i_obi_icn_ss_obi_reqpar = i_system_control_OBI_to_i_obi_icn_ss_OBI_reqpar;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rid = i_obi_icn_ss_obi_rid;
    assign i_obi_icn_ss_obi_rready = i_system_control_OBI_to_i_obi_icn_ss_OBI_rready;
    assign i_obi_icn_ss_obi_rreadypar = i_system_control_OBI_to_i_obi_icn_ss_OBI_rreadypar;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalid = i_obi_icn_ss_obi_rvalid;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalidpar = i_obi_icn_ss_obi_rvalidpar;
    assign i_obi_icn_ss_obi_wdata = i_system_control_OBI_to_i_obi_icn_ss_OBI_wdata;
    assign i_obi_icn_ss_obi_we = i_system_control_OBI_to_i_obi_icn_ss_OBI_we;
    assign i_obi_icn_ss_reset_n = i_obi_icn_ss_reset_to_i_system_control_Reset_icn_reset;
    assign i_obi_icn_ss_ss_ctrl_icn = i_system_control_ICN_SS_Ctrl_to_i_obi_icn_ss_icn_ss_ctrl_clk_ctrl;
    // i_system_control assignments:
    assign i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpi = i_system_control_analog_pmod_gpi;
    assign i_system_control_analog_pmod_gpio_oe = i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpio_oe;
    assign i_system_control_analog_pmod_gpo = i_system_control_analog_pmod_gpio_to_analog_wrapper_pmod_gpio_gpo;
    assign i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk = i_system_control_clk;
    assign i_system_control_clk_ctrl_to_analog_wrapper_clk_en = i_system_control_clk_ctrl[0];
    assign i_system_control_clk_ctrl_to_student_wrapper_3_clk_en = i_system_control_clk_ctrl[3];
    assign i_system_control_clk_ctrl_to_student_wrapper_4_clk_en = i_system_control_clk_ctrl[4];
    assign i_system_control_clk_ctrl_to_student_wrapper_5_clk_en = i_system_control_clk_ctrl[5];
    assign i_system_control_clk_ctrl_to_student_wrapper_6_clk_en = i_system_control_clk_ctrl[6];
    assign i_system_control_clk_ctrl_to_student_wrapper_7_clk_en = i_system_control_clk_ctrl[7];
    assign student_wrapper_1_clk_en_to_i_system_control_clk_ctrl = i_system_control_clk_ctrl[1];
    assign student_wrapper_2_clk_en_to_i_system_control_clk_ctrl = i_system_control_clk_ctrl[2];
    assign i_system_control_clock_in = i_system_control_Clock_to_Clock_clock_in;
    assign i_system_control_irq_en_to_analog_wrapper_irq_en = i_system_control_irq_en;
    assign student_wrapper_1_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[1];
    assign student_wrapper_2_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[2];
    assign student_wrapper_3_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[3];
    assign student_wrapper_4_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[4];
    assign student_wrapper_5_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[5];
    assign student_wrapper_6_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[6];
    assign student_wrapper_7_irq_en_to_i_system_control_irq_en = i_system_control_irq_en[7];
    assign i_system_control_irq_i[0] = analog_wrapper_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[1] = student_wrapper_1_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[2] = student_wrapper_2_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[3] = student_wrapper_3_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[4] = student_wrapper_4_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[5] = student_wrapper_5_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[6] = student_wrapper_6_irq_to_i_system_control_irq_i;
    assign i_system_control_irq_i[7] = student_wrapper_7_irq_to_i_system_control_irq_i;
    assign i_system_control_jtag_tck = i_system_control_JTAG_to_JTAG_tck;
    assign i_system_control_jtag_tdi = i_system_control_JTAG_to_JTAG_tdi;
    assign i_system_control_JTAG_to_JTAG_tdo = i_system_control_jtag_tdo;
    assign i_system_control_jtag_tms = i_system_control_JTAG_to_JTAG_tms;
    assign i_system_control_jtag_trst = i_system_control_JTAG_to_JTAG_trst;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_addr = i_system_control_obi_addr;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_aid = i_system_control_obi_aid;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_be = i_system_control_obi_be;
    assign i_system_control_obi_err = i_system_control_OBI_to_i_obi_icn_ss_OBI_err;
    assign i_system_control_obi_gnt = i_system_control_OBI_to_i_obi_icn_ss_OBI_gnt;
    assign i_system_control_obi_gntpar = i_system_control_OBI_to_i_obi_icn_ss_OBI_gntpar;
    assign i_system_control_obi_rdata = i_system_control_OBI_to_i_obi_icn_ss_OBI_rdata;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_req = i_system_control_obi_req;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_reqpar = i_system_control_obi_reqpar;
    assign i_system_control_obi_rid = i_system_control_OBI_to_i_obi_icn_ss_OBI_rid;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rready = i_system_control_obi_rready;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_rreadypar = i_system_control_obi_rreadypar;
    assign i_system_control_obi_rvalid = i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalid;
    assign i_system_control_obi_rvalidpar = i_system_control_OBI_to_i_obi_icn_ss_OBI_rvalidpar;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_wdata = i_system_control_obi_wdata;
    assign i_system_control_OBI_to_i_obi_icn_ss_OBI_we = i_system_control_obi_we;
    assign i_system_control_reset = i_system_control_Reset_to_Reset_n_reset;
    assign i_obi_icn_ss_reset_to_i_system_control_Reset_icn_reset = i_system_control_reset_int;
    assign i_system_control_reset_ss_to_analog_wrapper_reset_n = i_system_control_reset_ss[0];
    assign i_system_control_reset_ss_to_student_wrapper_1_reset = i_system_control_reset_ss[1];
    assign i_system_control_reset_ss_to_student_wrapper_2_reset = i_system_control_reset_ss[2];
    assign i_system_control_reset_ss_to_student_wrapper_3_reset = i_system_control_reset_ss[3];
    assign i_system_control_reset_ss_to_student_wrapper_4_reset = i_system_control_reset_ss[4];
    assign i_system_control_reset_ss_to_student_wrapper_5_reset = i_system_control_reset_ss[5];
    assign student_wrapper_6_reset_to_i_system_control_reset_ss = i_system_control_reset_ss[6];
    assign student_wrapper_7_reset_to_i_system_control_reset_ss = i_system_control_reset_ss[7];
    assign i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpi = i_system_control_slot1_pmod_gpi;
    assign i_system_control_slot1_pmod_gpio_oe = i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpio_oe;
    assign i_system_control_slot1_pmod_gpo = i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpo;
    assign i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpi = i_system_control_slot2_pmod_gpi;
    assign i_system_control_slot2_pmod_gpio_oe = i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpio_oe;
    assign i_system_control_slot2_pmod_gpo = i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpo;
    assign i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpi = i_system_control_slot3_pmod_gpi;
    assign i_system_control_slot3_pmod_gpio_oe = i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpio_oe;
    assign i_system_control_slot3_pmod_gpo = i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpo;
    assign i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpi = i_system_control_slot4_pmod_gpi;
    assign i_system_control_slot4_pmod_gpio_oe = i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpio_oe;
    assign i_system_control_slot4_pmod_gpo = i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpo;
    assign i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpi = i_system_control_slot5_pmod_gpi;
    assign i_system_control_slot5_pmod_gpio_oe = i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpio_oe;
    assign i_system_control_slot5_pmod_gpo = i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpo;
    assign i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpi = i_system_control_slot6_pmod_gpi;
    assign i_system_control_slot6_pmod_gpio_oe = i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpio_oe;
    assign i_system_control_slot6_pmod_gpo = i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpo;
    assign i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpi = i_system_control_slot7_pmod_gpi;
    assign i_system_control_slot7_pmod_gpio_oe = i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpio_oe;
    assign i_system_control_slot7_pmod_gpo = i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpo;
    assign i_system_control_SPI_to_SPI_csn = i_system_control_spi_csn;
    assign i_system_control_SPI_to_SPI_sck = i_system_control_spi_sck;
    assign i_system_control_ICN_SS_Ctrl_to_i_obi_icn_ss_icn_ss_ctrl_clk_ctrl = i_system_control_ss_ctrl_icn;
    assign i_system_control_uart_rx = i_system_control_UART_to_UART_uart_rx;
    assign i_system_control_UART_to_UART_uart_tx = i_system_control_uart_tx;
    // student_wrapper_1 assignments:
    assign student_wrapper_1_PADDR = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PADDR;
    assign student_wrapper_1_PENABLE = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PENABLE;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PRDATA = student_wrapper_1_PRDATA;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PREADY = student_wrapper_1_PREADY;
    assign student_wrapper_1_PSEL = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSEL;
    assign i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSLVERR = student_wrapper_1_PSLVERR;
    assign student_wrapper_1_PSTRB = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PSTRB;
    assign student_wrapper_1_PWDATA = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWDATA;
    assign student_wrapper_1_PWRITE = i_obi_icn_ss_apb_1_to_student_wrapper_1_APB_PWRITE;
    assign student_wrapper_1_clk_en = student_wrapper_1_clk_en_to_i_system_control_clk_ctrl;
    assign student_wrapper_1_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_1_irq_to_i_system_control_irq_i = student_wrapper_1_irq;
    assign student_wrapper_1_irq_en = student_wrapper_1_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_1_pmod_gpi = i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpi;
    assign i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpio_oe = student_wrapper_1_pmod_gpio_oe;
    assign i_system_control_group1_pmod_gpio_to_student_wrapper_1_pmod_gpio_gpo = student_wrapper_1_pmod_gpo;
    assign student_wrapper_1_reset_n = i_system_control_reset_ss_to_student_wrapper_1_reset;
    // student_wrapper_2 assignments:
    assign student_wrapper_2_PADDR = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PADDR;
    assign student_wrapper_2_PENABLE = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PENABLE;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PRDATA = student_wrapper_2_PRDATA;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PREADY = student_wrapper_2_PREADY;
    assign student_wrapper_2_PSEL = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSEL;
    assign i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSLVERR = student_wrapper_2_PSLVERR;
    assign student_wrapper_2_PSTRB = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PSTRB;
    assign student_wrapper_2_PWDATA = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWDATA;
    assign student_wrapper_2_PWRITE = i_obi_icn_ss_apb_2_to_student_wrapper_2_APB_PWRITE;
    assign student_wrapper_2_clk_en = student_wrapper_2_clk_en_to_i_system_control_clk_ctrl;
    assign student_wrapper_2_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_2_irq_to_i_system_control_irq_i = student_wrapper_2_irq;
    assign student_wrapper_2_irq_en = student_wrapper_2_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_2_pmod_gpi = i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpi;
    assign i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpio_oe = student_wrapper_2_pmod_gpio_oe;
    assign i_system_control_group2_pmod_gpio_to_student_wrapper_2_pmod_gpio_gpo = student_wrapper_2_pmod_gpo;
    assign student_wrapper_2_reset_n = i_system_control_reset_ss_to_student_wrapper_2_reset;
    // student_wrapper_3 assignments:
    assign student_wrapper_3_PADDR = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PADDR;
    assign student_wrapper_3_PENABLE = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PENABLE;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PRDATA = student_wrapper_3_PRDATA;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PREADY = student_wrapper_3_PREADY;
    assign student_wrapper_3_PSEL = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSEL;
    assign i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSLVERR = student_wrapper_3_PSLVERR;
    assign student_wrapper_3_PSTRB = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PSTRB;
    assign student_wrapper_3_PWDATA = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWDATA;
    assign student_wrapper_3_PWRITE = i_obi_icn_ss_apb_3_to_student_wrapper_3_APB_PWRITE;
    assign student_wrapper_3_clk_en = i_system_control_clk_ctrl_to_student_wrapper_3_clk_en;
    assign student_wrapper_3_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_3_irq_to_i_system_control_irq_i = student_wrapper_3_irq;
    assign student_wrapper_3_irq_en = student_wrapper_3_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_3_pmod_gpi = i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpi;
    assign i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpio_oe = student_wrapper_3_pmod_gpio_oe;
    assign i_system_control_group3_pmod_gpio_to_student_wrapper_3_pmod_gpio_gpo = student_wrapper_3_pmod_gpo;
    assign student_wrapper_3_reset_n = i_system_control_reset_ss_to_student_wrapper_3_reset;
    // student_wrapper_4 assignments:
    assign student_wrapper_4_PADDR = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PADDR;
    assign student_wrapper_4_PENABLE = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PENABLE;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PRDATA = student_wrapper_4_PRDATA;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PREADY = student_wrapper_4_PREADY;
    assign student_wrapper_4_PSEL = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSEL;
    assign i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSLVERR = student_wrapper_4_PSLVERR;
    assign student_wrapper_4_PSTRB = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PSTRB;
    assign student_wrapper_4_PWDATA = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWDATA;
    assign student_wrapper_4_PWRITE = i_obi_icn_ss_apb_4_to_student_wrapper_4_APB_PWRITE;
    assign student_wrapper_4_clk_en = i_system_control_clk_ctrl_to_student_wrapper_4_clk_en;
    assign student_wrapper_4_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_4_irq_to_i_system_control_irq_i = student_wrapper_4_irq;
    assign student_wrapper_4_irq_en = student_wrapper_4_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_4_pmod_gpi = i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpi;
    assign i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpio_oe = student_wrapper_4_pmod_gpio_oe;
    assign i_system_control_group4_pmod_gpio_to_student_wrapper_4_pmod_gpio_gpo = student_wrapper_4_pmod_gpo;
    assign student_wrapper_4_reset_n = i_system_control_reset_ss_to_student_wrapper_4_reset;
    // student_wrapper_5 assignments:
    assign student_wrapper_5_PADDR = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PADDR;
    assign student_wrapper_5_PENABLE = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PENABLE;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PRDATA = student_wrapper_5_PRDATA;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PREADY = student_wrapper_5_PREADY;
    assign student_wrapper_5_PSEL = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSEL;
    assign i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSLVERR = student_wrapper_5_PSLVERR;
    assign student_wrapper_5_PSTRB = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PSTRB;
    assign student_wrapper_5_PWDATA = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWDATA;
    assign student_wrapper_5_PWRITE = i_obi_icn_ss_apb_5_to_student_wrapper_5_APB_PWRITE;
    assign student_wrapper_5_clk_en = i_system_control_clk_ctrl_to_student_wrapper_5_clk_en;
    assign student_wrapper_5_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_5_irq_to_i_system_control_irq_i = student_wrapper_5_irq;
    assign student_wrapper_5_irq_en = student_wrapper_5_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_5_pmod_gpi = i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpi;
    assign i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpio_oe = student_wrapper_5_pmod_gpio_oe;
    assign i_system_control_group5_pmod_gpio_to_student_wrapper_5_pmod_gpio_gpo = student_wrapper_5_pmod_gpo;
    assign student_wrapper_5_reset_n = i_system_control_reset_ss_to_student_wrapper_5_reset;
    // student_wrapper_6 assignments:
    assign student_wrapper_6_PADDR = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PADDR;
    assign student_wrapper_6_PENABLE = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PENABLE;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PRDATA = student_wrapper_6_PRDATA;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PREADY = student_wrapper_6_PREADY;
    assign student_wrapper_6_PSEL = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSEL;
    assign i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSLVERR = student_wrapper_6_PSLVERR;
    assign student_wrapper_6_PSTRB = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PSTRB;
    assign student_wrapper_6_PWDATA = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWDATA;
    assign student_wrapper_6_PWRITE = i_obi_icn_ss_apb_6_to_student_wrapper_6_APB_PWRITE;
    assign student_wrapper_6_clk_en = i_system_control_clk_ctrl_to_student_wrapper_6_clk_en;
    assign student_wrapper_6_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_6_irq_to_i_system_control_irq_i = student_wrapper_6_irq;
    assign student_wrapper_6_irq_en = student_wrapper_6_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_6_pmod_gpi = i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpi;
    assign i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpio_oe = student_wrapper_6_pmod_gpio_oe;
    assign i_system_control_group6_pmod_gpio_to_student_wrapper_6_pmod_gpio_gpo = student_wrapper_6_pmod_gpo;
    assign student_wrapper_6_reset_n = student_wrapper_6_reset_to_i_system_control_reset_ss;
    // student_wrapper_7 assignments:
    assign student_wrapper_7_PADDR = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PADDR;
    assign student_wrapper_7_PENABLE = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PENABLE;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PRDATA = student_wrapper_7_PRDATA;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PREADY = student_wrapper_7_PREADY;
    assign student_wrapper_7_PSEL = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSEL;
    assign i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSLVERR = student_wrapper_7_PSLVERR;
    assign student_wrapper_7_PSTRB = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PSTRB;
    assign student_wrapper_7_PWDATA = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWDATA;
    assign student_wrapper_7_PWRITE = i_obi_icn_ss_apb_7_to_student_wrapper_7_APB_PWRITE;
    assign student_wrapper_7_clk_en = i_system_control_clk_ctrl_to_student_wrapper_7_clk_en;
    assign student_wrapper_7_clk_in = i_system_control_Clock_int_to_i_obi_icn_ss_clock_clk;
    assign student_wrapper_7_irq_to_i_system_control_irq_i = student_wrapper_7_irq;
    assign student_wrapper_7_irq_en = student_wrapper_7_irq_en_to_i_system_control_irq_en;
    assign student_wrapper_7_pmod_gpi = i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpi;
    assign i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpio_oe = student_wrapper_7_pmod_gpio_oe;
    assign i_system_control_group7_pmod_gpio_to_student_wrapper_7_pmod_gpio_gpo = student_wrapper_7_pmod_gpo;
    assign student_wrapper_7_reset_n = student_wrapper_7_reset_to_i_system_control_reset_ss;

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:analog_wrapper:1.0
    analog_wrapper_0 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    analog_wrapper(
        // Interface: APB
        .PADDR               (analog_wrapper_PADDR),
        .PENABLE             (analog_wrapper_PENABLE),
        .PSEL                (analog_wrapper_PSEL),
        .PSTRB               (analog_wrapper_PSTRB),
        .PWDATA              (analog_wrapper_PWDATA),
        .PWRITE              (analog_wrapper_PWRITE),
        .PRDATA              (analog_wrapper_PRDATA),
        .PREADY              (analog_wrapper_PREADY),
        .PSLVERR             (analog_wrapper_PSLVERR),
        // Interface: Clock
        .clk_in              (analog_wrapper_clk_in),
        // Interface: IRQ
        .irq                 (analog_wrapper_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (analog_wrapper_pmod_gpi),
        .pmod_gpio_oe        (analog_wrapper_pmod_gpio_oe),
        .pmod_gpo            (analog_wrapper_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (analog_wrapper_clk_en),
        .irq_en              (analog_wrapper_irq_en),
        .reset_n             (analog_wrapper_reset_n));

    // IP-XACT VLNV: tuni.fi:interconnect:obi_icn_ss:1.0
    obi_icn_ss #(
        .OBI_AW              (32),
        .OBI_CHKW            (1),
        .OBI_DW              (32),
        .OBI_IDW             (1),
        .OBI_USERW           (1),
        .APB_DW              (32),
        .APB_AW              (32),
        .SS_CTRL_W           (8))
    i_obi_icn_ss(
        // Interface: OBI
        .obi_addr            (i_obi_icn_ss_obi_addr),
        .obi_aid             (i_obi_icn_ss_obi_aid),
        .obi_be              (i_obi_icn_ss_obi_be),
        .obi_req             (i_obi_icn_ss_obi_req),
        .obi_reqpar          (i_obi_icn_ss_obi_reqpar),
        .obi_rready          (i_obi_icn_ss_obi_rready),
        .obi_rreadypar       (i_obi_icn_ss_obi_rreadypar),
        .obi_wdata           (i_obi_icn_ss_obi_wdata),
        .obi_we              (i_obi_icn_ss_obi_we),
        .obi_err             (i_obi_icn_ss_obi_err),
        .obi_gnt             (i_obi_icn_ss_obi_gnt),
        .obi_gntpar          (i_obi_icn_ss_obi_gntpar),
        .obi_rdata           (i_obi_icn_ss_obi_rdata),
        .obi_rid             (i_obi_icn_ss_obi_rid),
        .obi_rvalid          (i_obi_icn_ss_obi_rvalid),
        .obi_rvalidpar       (i_obi_icn_ss_obi_rvalidpar),
        // Interface: apb_0
        .APB_0_PRDATA        (i_obi_icn_ss_APB_0_PRDATA),
        .APB_0_PREADY        (i_obi_icn_ss_APB_0_PREADY),
        .APB_0_PSLVERR       (i_obi_icn_ss_APB_0_PSLVERR),
        .APB_0_PADDR         (i_obi_icn_ss_APB_0_PADDR),
        .APB_0_PENABLE       (i_obi_icn_ss_APB_0_PENABLE),
        .APB_0_PSEL          (i_obi_icn_ss_APB_0_PSEL),
        .APB_0_PSTRB         (i_obi_icn_ss_APB_0_PSTRB),
        .APB_0_PWDATA        (i_obi_icn_ss_APB_0_PWDATA),
        .APB_0_PWRITE        (i_obi_icn_ss_APB_0_PWRITE),
        // Interface: apb_1
        .APB_1_PRDATA        (i_obi_icn_ss_APB_1_PRDATA),
        .APB_1_PREADY        (i_obi_icn_ss_APB_1_PREADY),
        .APB_1_PSLVERR       (i_obi_icn_ss_APB_1_PSLVERR),
        .APB_1_PADDR         (i_obi_icn_ss_APB_1_PADDR),
        .APB_1_PENABLE       (i_obi_icn_ss_APB_1_PENABLE),
        .APB_1_PSEL          (i_obi_icn_ss_APB_1_PSEL),
        .APB_1_PSTRB         (i_obi_icn_ss_APB_1_PSTRB),
        .APB_1_PWDATA        (i_obi_icn_ss_APB_1_PWDATA),
        .APB_1_PWRITE        (i_obi_icn_ss_APB_1_PWRITE),
        // Interface: apb_2
        .APB_2_PRDATA        (i_obi_icn_ss_APB_2_PRDATA),
        .APB_2_PREADY        (i_obi_icn_ss_APB_2_PREADY),
        .APB_2_PSLVERR       (i_obi_icn_ss_APB_2_PSLVERR),
        .APB_2_PADDR         (i_obi_icn_ss_APB_2_PADDR),
        .APB_2_PENABLE       (i_obi_icn_ss_APB_2_PENABLE),
        .APB_2_PSEL          (i_obi_icn_ss_APB_2_PSEL),
        .APB_2_PSTRB         (i_obi_icn_ss_APB_2_PSTRB),
        .APB_2_PWDATA        (i_obi_icn_ss_APB_2_PWDATA),
        .APB_2_PWRITE        (i_obi_icn_ss_APB_2_PWRITE),
        // Interface: apb_3
        .APB_3_PRDATA        (i_obi_icn_ss_APB_3_PRDATA),
        .APB_3_PREADY        (i_obi_icn_ss_APB_3_PREADY),
        .APB_3_PSLVERR       (i_obi_icn_ss_APB_3_PSLVERR),
        .APB_3_PADDR         (i_obi_icn_ss_APB_3_PADDR),
        .APB_3_PENABLE       (i_obi_icn_ss_APB_3_PENABLE),
        .APB_3_PSEL          (i_obi_icn_ss_APB_3_PSEL),
        .APB_3_PSTRB         (i_obi_icn_ss_APB_3_PSTRB),
        .APB_3_PWDATA        (i_obi_icn_ss_APB_3_PWDATA),
        .APB_3_PWRITE        (i_obi_icn_ss_APB_3_PWRITE),
        // Interface: apb_4
        .APB_4_PRDATA        (i_obi_icn_ss_APB_4_PRDATA),
        .APB_4_PREADY        (i_obi_icn_ss_APB_4_PREADY),
        .APB_4_PSLVERR       (i_obi_icn_ss_APB_4_PSLVERR),
        .APB_4_PADDR         (i_obi_icn_ss_APB_4_PADDR),
        .APB_4_PENABLE       (i_obi_icn_ss_APB_4_PENABLE),
        .APB_4_PSEL          (i_obi_icn_ss_APB_4_PSEL),
        .APB_4_PSTRB         (i_obi_icn_ss_APB_4_PSTRB),
        .APB_4_PWDATA        (i_obi_icn_ss_APB_4_PWDATA),
        .APB_4_PWRITE        (i_obi_icn_ss_APB_4_PWRITE),
        // Interface: apb_5
        .APB_5_PRDATA        (i_obi_icn_ss_APB_5_PRDATA),
        .APB_5_PREADY        (i_obi_icn_ss_APB_5_PREADY),
        .APB_5_PSLVERR       (i_obi_icn_ss_APB_5_PSLVERR),
        .APB_5_PADDR         (i_obi_icn_ss_APB_5_PADDR),
        .APB_5_PENABLE       (i_obi_icn_ss_APB_5_PENABLE),
        .APB_5_PSEL          (i_obi_icn_ss_APB_5_PSEL),
        .APB_5_PSTRB         (i_obi_icn_ss_APB_5_PSTRB),
        .APB_5_PWDATA        (i_obi_icn_ss_APB_5_PWDATA),
        .APB_5_PWRITE        (i_obi_icn_ss_APB_5_PWRITE),
        // Interface: apb_6
        .APB_6_PRDATA        (i_obi_icn_ss_APB_6_PRDATA),
        .APB_6_PREADY        (i_obi_icn_ss_APB_6_PREADY),
        .APB_6_PSLVERR       (i_obi_icn_ss_APB_6_PSLVERR),
        .APB_6_PADDR         (i_obi_icn_ss_APB_6_PADDR),
        .APB_6_PENABLE       (i_obi_icn_ss_APB_6_PENABLE),
        .APB_6_PSEL          (i_obi_icn_ss_APB_6_PSEL),
        .APB_6_PSTRB         (i_obi_icn_ss_APB_6_PSTRB),
        .APB_6_PWDATA        (i_obi_icn_ss_APB_6_PWDATA),
        .APB_6_PWRITE        (i_obi_icn_ss_APB_6_PWRITE),
        // Interface: apb_7
        .APB_7_PRDATA        (i_obi_icn_ss_APB_7_PRDATA),
        .APB_7_PREADY        (i_obi_icn_ss_APB_7_PREADY),
        .APB_7_PSLVERR       (i_obi_icn_ss_APB_7_PSLVERR),
        .APB_7_PADDR         (i_obi_icn_ss_APB_7_PADDR),
        .APB_7_PENABLE       (i_obi_icn_ss_APB_7_PENABLE),
        .APB_7_PSEL          (i_obi_icn_ss_APB_7_PSEL),
        .APB_7_PSTRB         (i_obi_icn_ss_APB_7_PSTRB),
        .APB_7_PWDATA        (i_obi_icn_ss_APB_7_PWDATA),
        .APB_7_PWRITE        (i_obi_icn_ss_APB_7_PWRITE),
        // Interface: clock
        .clk                 (i_obi_icn_ss_clk),
        // Interface: icn_ss_ctrl
        .ss_ctrl_icn         (i_obi_icn_ss_ss_ctrl_icn),
        // Interface: reset
        .reset_n             (i_obi_icn_ss_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:SysCtrl_SS_wrapper:1.2
    SysCtrl_SS_wrapper_0 #(
        .OBI_AW              (32),
        .OBI_DW              (32),
        .SS_CTRL_W           (8),
        .NUM_GPIO            (16),
        .IOCELL_COUNT        (32),
        .IOCELL_CFGW         (7),
        .NUM_SS              (8),
        .OBI_IDW             (1))
    i_system_control(
        // Interface: Clock
        .clock_in            (i_system_control_clock_in),
        // Interface: Clock_int
        .clk                 (i_system_control_clk),
        // Interface: GPIO
        .gpio                (gpio[15:0]),
        // Interface: ICN_SS_Ctrl
        .ss_ctrl_icn         (i_system_control_ss_ctrl_icn),
        // Interface: IRQ
        .irq_i               (i_system_control_irq_i),
        // Interface: JTAG
        .jtag_tck            (i_system_control_jtag_tck),
        .jtag_tdi            (i_system_control_jtag_tdi),
        .jtag_tms            (i_system_control_jtag_tms),
        .jtag_trst           (i_system_control_jtag_trst),
        .jtag_tdo            (i_system_control_jtag_tdo),
        // Interface: OBI
        .obi_err             (i_system_control_obi_err),
        .obi_gnt             (i_system_control_obi_gnt),
        .obi_gntpar          (i_system_control_obi_gntpar),
        .obi_rdata           (i_system_control_obi_rdata),
        .obi_rid             (i_system_control_obi_rid),
        .obi_rvalid          (i_system_control_obi_rvalid),
        .obi_rvalidpar       (i_system_control_obi_rvalidpar),
        .obi_addr            (i_system_control_obi_addr),
        .obi_aid             (i_system_control_obi_aid),
        .obi_be              (i_system_control_obi_be),
        .obi_req             (i_system_control_obi_req),
        .obi_reqpar          (i_system_control_obi_reqpar),
        .obi_rready          (i_system_control_obi_rready),
        .obi_rreadypar       (i_system_control_obi_rreadypar),
        .obi_wdata           (i_system_control_obi_wdata),
        .obi_we              (i_system_control_obi_we),
        // Interface: Reset
        .reset               (i_system_control_reset),
        // Interface: Reset_SS
        .reset_ss            (i_system_control_reset_ss),
        // Interface: Reset_icn
        .reset_int           (i_system_control_reset_int),
        // Interface: SPI
        .spi_csn             (i_system_control_spi_csn),
        .spi_sck             (i_system_control_spi_sck),
        .spi_data            (spi_data[3:0]),
        // Interface: UART
        .uart_rx             (i_system_control_uart_rx),
        .uart_tx             (i_system_control_uart_tx),
        // Interface: analog_pmod_gpio
        .analog_pmod_gpio_oe (i_system_control_analog_pmod_gpio_oe),
        .analog_pmod_gpo     (i_system_control_analog_pmod_gpo),
        .analog_pmod_gpi     (i_system_control_analog_pmod_gpi),
        // Interface: group1_pmod_gpio
        .slot1_pmod_gpio_oe  (i_system_control_slot1_pmod_gpio_oe),
        .slot1_pmod_gpo      (i_system_control_slot1_pmod_gpo),
        .slot1_pmod_gpi      (i_system_control_slot1_pmod_gpi),
        // Interface: group2_pmod_gpio
        .slot2_pmod_gpio_oe  (i_system_control_slot2_pmod_gpio_oe),
        .slot2_pmod_gpo      (i_system_control_slot2_pmod_gpo),
        .slot2_pmod_gpi      (i_system_control_slot2_pmod_gpi),
        // Interface: group3_pmod_gpio
        .slot3_pmod_gpio_oe  (i_system_control_slot3_pmod_gpio_oe),
        .slot3_pmod_gpo      (i_system_control_slot3_pmod_gpo),
        .slot3_pmod_gpi      (i_system_control_slot3_pmod_gpi),
        // Interface: group4_pmod_gpio
        .slot4_pmod_gpio_oe  (i_system_control_slot4_pmod_gpio_oe),
        .slot4_pmod_gpo      (i_system_control_slot4_pmod_gpo),
        .slot4_pmod_gpi      (i_system_control_slot4_pmod_gpi),
        // Interface: group5_pmod_gpio
        .slot5_pmod_gpio_oe  (i_system_control_slot5_pmod_gpio_oe),
        .slot5_pmod_gpo      (i_system_control_slot5_pmod_gpo),
        .slot5_pmod_gpi      (i_system_control_slot5_pmod_gpi),
        // Interface: group6_pmod_gpio
        .slot6_pmod_gpio_oe  (i_system_control_slot6_pmod_gpio_oe),
        .slot6_pmod_gpo      (i_system_control_slot6_pmod_gpo),
        .slot6_pmod_gpi      (i_system_control_slot6_pmod_gpi),
        // Interface: group7_pmod_gpio
        .slot7_pmod_gpio_oe  (i_system_control_slot7_pmod_gpio_oe),
        .slot7_pmod_gpo      (i_system_control_slot7_pmod_gpo),
        .slot7_pmod_gpi      (i_system_control_slot7_pmod_gpi),
        // Interface: ss_ctrl
        .clk_ctrl            (i_system_control_clk_ctrl),
        .irq_en              (i_system_control_irq_en));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_0 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_1(
        // Interface: APB
        .PADDR               (student_wrapper_1_PADDR),
        .PENABLE             (student_wrapper_1_PENABLE),
        .PSEL                (student_wrapper_1_PSEL),
        .PSTRB               (student_wrapper_1_PSTRB),
        .PWDATA              (student_wrapper_1_PWDATA),
        .PWRITE              (student_wrapper_1_PWRITE),
        .PRDATA              (student_wrapper_1_PRDATA),
        .PREADY              (student_wrapper_1_PREADY),
        .PSLVERR             (student_wrapper_1_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_1_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_1_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_1_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_1_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_1_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_1_clk_en),
        .irq_en              (student_wrapper_1_irq_en),
        .reset_n             (student_wrapper_1_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_1 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_2(
        // Interface: APB
        .PADDR               (student_wrapper_2_PADDR),
        .PENABLE             (student_wrapper_2_PENABLE),
        .PSEL                (student_wrapper_2_PSEL),
        .PSTRB               (student_wrapper_2_PSTRB),
        .PWDATA              (student_wrapper_2_PWDATA),
        .PWRITE              (student_wrapper_2_PWRITE),
        .PRDATA              (student_wrapper_2_PRDATA),
        .PREADY              (student_wrapper_2_PREADY),
        .PSLVERR             (student_wrapper_2_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_2_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_2_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_2_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_2_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_2_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_2_clk_en),
        .irq_en              (student_wrapper_2_irq_en),
        .reset_n             (student_wrapper_2_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_2 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_3(
        // Interface: APB
        .PADDR               (student_wrapper_3_PADDR),
        .PENABLE             (student_wrapper_3_PENABLE),
        .PSEL                (student_wrapper_3_PSEL),
        .PSTRB               (student_wrapper_3_PSTRB),
        .PWDATA              (student_wrapper_3_PWDATA),
        .PWRITE              (student_wrapper_3_PWRITE),
        .PRDATA              (student_wrapper_3_PRDATA),
        .PREADY              (student_wrapper_3_PREADY),
        .PSLVERR             (student_wrapper_3_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_3_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_3_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_3_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_3_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_3_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_3_clk_en),
        .irq_en              (student_wrapper_3_irq_en),
        .reset_n             (student_wrapper_3_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_3 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_4(
        // Interface: APB
        .PADDR               (student_wrapper_4_PADDR),
        .PENABLE             (student_wrapper_4_PENABLE),
        .PSEL                (student_wrapper_4_PSEL),
        .PSTRB               (student_wrapper_4_PSTRB),
        .PWDATA              (student_wrapper_4_PWDATA),
        .PWRITE              (student_wrapper_4_PWRITE),
        .PRDATA              (student_wrapper_4_PRDATA),
        .PREADY              (student_wrapper_4_PREADY),
        .PSLVERR             (student_wrapper_4_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_4_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_4_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_4_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_4_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_4_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_4_clk_en),
        .irq_en              (student_wrapper_4_irq_en),
        .reset_n             (student_wrapper_4_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_4 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_5(
        // Interface: APB
        .PADDR               (student_wrapper_5_PADDR),
        .PENABLE             (student_wrapper_5_PENABLE),
        .PSEL                (student_wrapper_5_PSEL),
        .PSTRB               (student_wrapper_5_PSTRB),
        .PWDATA              (student_wrapper_5_PWDATA),
        .PWRITE              (student_wrapper_5_PWRITE),
        .PRDATA              (student_wrapper_5_PRDATA),
        .PREADY              (student_wrapper_5_PREADY),
        .PSLVERR             (student_wrapper_5_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_5_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_5_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_5_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_5_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_5_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_5_clk_en),
        .irq_en              (student_wrapper_5_irq_en),
        .reset_n             (student_wrapper_5_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_5 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_6(
        // Interface: APB
        .PADDR               (student_wrapper_6_PADDR),
        .PENABLE             (student_wrapper_6_PENABLE),
        .PSEL                (student_wrapper_6_PSEL),
        .PSTRB               (student_wrapper_6_PSTRB),
        .PWDATA              (student_wrapper_6_PWDATA),
        .PWRITE              (student_wrapper_6_PWRITE),
        .PRDATA              (student_wrapper_6_PRDATA),
        .PREADY              (student_wrapper_6_PREADY),
        .PSLVERR             (student_wrapper_6_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_6_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_6_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_6_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_6_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_6_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_6_clk_en),
        .irq_en              (student_wrapper_6_irq_en),
        .reset_n             (student_wrapper_6_reset_n));

    // IP-XACT VLNV: tuni.fi:subsystem.wrapper:student_wrapper:1.0
    student_wrapper_6 #(
        .APB_DW              (32),
        .APB_AW              (32),
        .NUM_GPIO            (16))
    student_wrapper_7(
        // Interface: APB
        .PADDR               (student_wrapper_7_PADDR),
        .PENABLE             (student_wrapper_7_PENABLE),
        .PSEL                (student_wrapper_7_PSEL),
        .PSTRB               (student_wrapper_7_PSTRB),
        .PWDATA              (student_wrapper_7_PWDATA),
        .PWRITE              (student_wrapper_7_PWRITE),
        .PRDATA              (student_wrapper_7_PRDATA),
        .PREADY              (student_wrapper_7_PREADY),
        .PSLVERR             (student_wrapper_7_PSLVERR),
        // Interface: Clock
        .clk_in              (student_wrapper_7_clk_in),
        // Interface: IRQ
        .irq                 (student_wrapper_7_irq),
        // Interface: pmod_gpio
        .pmod_gpi            (student_wrapper_7_pmod_gpi),
        .pmod_gpio_oe        (student_wrapper_7_pmod_gpio_oe),
        .pmod_gpo            (student_wrapper_7_pmod_gpo),
        // These ports are not in any interface
        .clk_en              (student_wrapper_7_clk_en),
        .irq_en              (student_wrapper_7_irq_en),
        .reset_n             (student_wrapper_7_reset_n));


endmodule
