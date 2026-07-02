//-----------------------------------------------------------------------------
// File          : obi_icn_ss.v
// Creation date : 08.05.2026
// Creation time : 14:22:27
// Description   : 
// Created by    : genssler
// Tool : Kactus2 3.14.0 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:interconnect:obi_icn_ss:1.0
// whose XML file is /home/genp/work/msmcd-fe-lab/Didactic-SoC/ipxact/tuni.fi/interconnect/obi_icn_ss/1.0/obi_icn_ss.1.0.xml
//-----------------------------------------------------------------------------

module obi_icn_ss #(
    parameter                              APB_AW           = 32,
    parameter                              APB_DW           = 32,
    parameter                              OBI_AW           = 32,
    parameter                              OBI_CHKW         = 1,
    parameter                              OBI_DW           = 32,
    parameter                              OBI_IDW          = 1,
    parameter                              OBI_USERW        = 1,
    parameter                              SS_CTRL_W        = 7
) (
    // Interface: OBI
    input  logic         [OBI_AW-1:0]   obi_addr,
    input  logic         [OBI_IDW-1:0]  obi_aid,
    input  logic         [OBI_DW/8-1:0] obi_be,
    input  logic                        obi_req,
    input  logic                        obi_reqpar,
    input  logic                        obi_rready,
    input  logic                        obi_rreadypar,
    input  logic         [OBI_DW-1:0]   obi_wdata,
    input  logic                        obi_we,
    output logic                        obi_err,
    output logic                        obi_gnt,
    output logic                        obi_gntpar,
    output logic         [OBI_DW-1:0]   obi_rdata,
    output logic         [OBI_IDW-1:0]  obi_rid,
    output logic                        obi_rvalid,
    output logic                        obi_rvalidpar,

    // Interface: apb_0
    input  logic         [APB_DW-1:0]   APB_0_PRDATA,
    input  logic                        APB_0_PREADY,
    input  logic                        APB_0_PSLVERR,
    output logic         [APB_AW-1:0]   APB_0_PADDR,
    output logic                        APB_0_PENABLE,
    output logic                        APB_0_PSEL,
    output logic         [APB_DW/8-1:0] APB_0_PSTRB,
    output logic         [APB_DW-1:0]   APB_0_PWDATA,
    output logic                        APB_0_PWRITE,

    // Interface: apb_1
    input  logic         [APB_DW-1:0]   APB_1_PRDATA,
    input  logic                        APB_1_PREADY,
    input  logic                        APB_1_PSLVERR,
    output logic         [APB_AW-1:0]   APB_1_PADDR,
    output logic                        APB_1_PENABLE,
    output logic                        APB_1_PSEL,
    output logic         [APB_DW/8-1:0] APB_1_PSTRB,
    output logic         [APB_DW-1:0]   APB_1_PWDATA,
    output logic                        APB_1_PWRITE,

    // Interface: apb_2
    input  logic         [APB_DW-1:0]   APB_2_PRDATA,
    input  logic                        APB_2_PREADY,
    input  logic                        APB_2_PSLVERR,
    output logic         [APB_AW-1:0]   APB_2_PADDR,
    output logic                        APB_2_PENABLE,
    output logic                        APB_2_PSEL,
    output logic         [APB_DW/8-1:0] APB_2_PSTRB,
    output logic         [APB_DW-1:0]   APB_2_PWDATA,
    output logic                        APB_2_PWRITE,

    // Interface: apb_3
    input  logic         [APB_DW-1:0]   APB_3_PRDATA,
    input  logic                        APB_3_PREADY,
    input  logic                        APB_3_PSLVERR,
    output logic         [APB_AW-1:0]   APB_3_PADDR,
    output logic                        APB_3_PENABLE,
    output logic                        APB_3_PSEL,
    output logic         [APB_DW/8-1:0] APB_3_PSTRB,
    output logic         [APB_DW-1:0]   APB_3_PWDATA,
    output logic                        APB_3_PWRITE,

    // Interface: apb_4
    input  logic         [APB_DW-1:0]   APB_4_PRDATA,
    input  logic                        APB_4_PREADY,
    input  logic                        APB_4_PSLVERR,
    output logic         [APB_AW-1:0]   APB_4_PADDR,
    output logic                        APB_4_PENABLE,
    output logic                        APB_4_PSEL,
    output logic         [APB_DW/8-1:0] APB_4_PSTRB,
    output logic         [APB_DW-1:0]   APB_4_PWDATA,
    output logic                        APB_4_PWRITE,

    // Interface: apb_5
    input  logic         [APB_DW-1:0]   APB_5_PRDATA,
    input  logic                        APB_5_PREADY,
    input  logic                        APB_5_PSLVERR,
    output logic         [APB_AW-1:0]   APB_5_PADDR,
    output logic                        APB_5_PENABLE,
    output logic                        APB_5_PSEL,
    output logic         [APB_DW/8-1:0] APB_5_PSTRB,
    output logic         [APB_DW-1:0]   APB_5_PWDATA,
    output logic                        APB_5_PWRITE,

    // Interface: apb_6
    input  logic         [APB_DW-1:0]   APB_6_PRDATA,
    input  logic                        APB_6_PREADY,
    input  logic                        APB_6_PSLVERR,
    output logic         [APB_AW-1:0]   APB_6_PADDR,
    output logic                        APB_6_PENABLE,
    output logic                        APB_6_PSEL,
    output logic         [APB_DW/8-1:0] APB_6_PSTRB,
    output logic         [APB_DW-1:0]   APB_6_PWDATA,
    output logic                        APB_6_PWRITE,

    // Interface: apb_7
    input  logic         [APB_DW-1:0]   APB_7_PRDATA,
    input  logic                        APB_7_PREADY,
    input  logic                        APB_7_PSLVERR,
    output logic         [APB_AW-1:0]   APB_7_PADDR,
    output logic                        APB_7_PENABLE,
    output logic                        APB_7_PSEL,
    output logic         [APB_DW/8-1:0] APB_7_PSTRB,
    output logic         [APB_DW-1:0]   APB_7_PWDATA,
    output logic                        APB_7_PWRITE,

    // Interface: clock
    input  logic                        clk,

    // Interface: icn_ss_ctrl
    input  logic         [SS_CTRL_W-1:0] ss_ctrl_icn,

    // Interface: reset
    input  logic                        reset_n
);

// WARNING: EVERYTHING ON AND ABOVE THIS LINE MAY BE OVERWRITTEN BY KACTUS2!!!


  localparam NUM_SS            =   8;
  localparam INITIATORS         = 1+1;//actual + tieoff
  localparam ICN_INITIATOR_CUTS =   0;
  localparam ICN_TARGET_CUTS    =   0;

  typedef struct packed {
    int unsigned idx;
    int unsigned start_addr;
    int unsigned end_addr;
  } addr_rule_t;

  localparam ADDR_BASE = 32'h0150_0000;
  localparam SS_SIZE   = 32'h0001_0000;

  addr_rule_t [NUM_SS-1:0] icn_addr_map;

  assign icn_addr_map =
    '{
      '{idx: 32'd7, start_addr: ADDR_BASE+SS_SIZE*0, end_addr: ADDR_BASE+SS_SIZE*(0+1)},//
      '{idx: 32'd6, start_addr: ADDR_BASE+SS_SIZE*1, end_addr: ADDR_BASE+SS_SIZE*(1+1)},//
      '{idx: 32'd5, start_addr: ADDR_BASE+SS_SIZE*2, end_addr: ADDR_BASE+SS_SIZE*(2+1)},//
      '{idx: 32'd4, start_addr: ADDR_BASE+SS_SIZE*3, end_addr: ADDR_BASE+SS_SIZE*(3+1)},//
      '{idx: 32'd3, start_addr: ADDR_BASE+SS_SIZE*4, end_addr: ADDR_BASE+SS_SIZE*(4+1)},//
      '{idx: 32'd2, start_addr: ADDR_BASE+SS_SIZE*5, end_addr: ADDR_BASE+SS_SIZE*(5+1)},//
      '{idx: 32'd1, start_addr: ADDR_BASE+SS_SIZE*6, end_addr: ADDR_BASE+SS_SIZE*(6+1)},//
      '{idx: 32'd0, start_addr: ADDR_BASE+SS_SIZE*7, end_addr: ADDR_BASE+SS_SIZE*(7+1)} //
     };

  // bus defaults 32 
  OBI_BUS #() target_bus [NUM_SS-1:0]();
  OBI_BUS #() target_bus_cut [NUM_SS-1:0]();
  OBI_BUS #() initiator_bus [INITIATORS-1-1:0] ();//no tieoff
  OBI_BUS #() initiator_bus_cut [INITIATORS-1:0] ();
  APB #() icn_bus [0:NUM_SS-1] ();  // reversed order to map index 0 to APB0
 
  if(ICN_INITIATOR_CUTS) begin
    obi_cut_intf #(
      .Bypass(1'b0)
    ) i_initiator_cut(
      .clk_i(clk),
      .rst_ni(reset_n),
      .obi_s(initiator_bus[0]),
      .obi_m(initiator_bus_cut[0])
    );
  end
  else begin
    obi_cut_intf #(
      .Bypass(1'b1)
    ) i_initiator_bypass_cut(
      .clk_i(clk),
      .rst_ni(reset_n),
      .obi_s(initiator_bus[0]),
      .obi_m(initiator_bus_cut[0])
    );
  end

  if(ICN_TARGET_CUTS) begin
    for (genvar i = 0; i < NUM_SS; i++) begin : target_cuts
      obi_cut_intf #(
        .Bypass(1'b0)
      ) i_target_cut(
        .clk_i(clk),
        .rst_ni(reset_n),
        .obi_s(target_bus[i]),
        .obi_m(target_bus_cut[i])
      );
    end
  end
  else begin
    for (genvar i = 0; i < NUM_SS; i++) begin : target_no_cuts
      obi_cut_intf #(
        .Bypass(1'b1)
      ) i_target_cut(
        .clk_i(clk),
        .rst_ni(reset_n),
        .obi_s(target_bus[i]),
        .obi_m(target_bus_cut[i])
      );
    end
  end


  obi_xbar_intf #(
    .NumSbrPorts       (INITIATORS),
    .NumMgrPorts       (NUM_SS),
    .NumMaxTrans       (1),
    .NumAddrRules      (NUM_SS),
    .addr_map_rule_t   (addr_rule_t),
    .UseIdForRouting   (0)
  ) i_icn_obi_xbar (
    .clk_i            (clk),
    .rst_ni           (reset_n),
    .testmode_i       (1'b0),
    .sbr_ports        (initiator_bus_cut),
    .mgr_ports        (target_bus),
    .addr_map_i       (icn_addr_map),
    .en_default_idx_i ('0),
    .default_idx_i    ('0)
  );

  for(genvar i=0; i<NUM_SS; i++) begin: gen_obi_to_apb
    obi_to_apb_intf #() i_obi_to_apb (
      .clk_i (clk),
      .rst_ni(reset_n),
      .obi_i (target_bus_cut[i]),
      .apb_o (icn_bus[i])
    );
  end

  // tieoff master connection for utilizing xbar as splitter
  assign initiator_bus_cut[1].addr = 'h0;
  assign initiator_bus_cut[1].aid = 'h0;
  assign initiator_bus_cut[1].be = 4'b1111;
  assign initiator_bus_cut[1].req = 1'b0;
  assign initiator_bus_cut[1].reqpar = 1'b1;
  assign initiator_bus_cut[1].rready = 1'b0;
  assign initiator_bus_cut[1].rreadypar = 1'b1;
  assign initiator_bus_cut[1].wdata = 'h0;
  assign initiator_bus_cut[1].we = 1'b0;

   // Interface: apb_0
   assign icn_bus[0].prdata = APB_0_PRDATA;
   assign icn_bus[0].pready = APB_0_PREADY;
   assign icn_bus[0].pslverr = APB_0_PSLVERR;
   assign APB_0_PADDR = icn_bus[0].paddr;
   assign APB_0_PENABLE = icn_bus[0].penable;
   assign APB_0_PSEL = icn_bus[0].psel;
   assign APB_0_PWDATA = icn_bus[0].pwdata;
   assign APB_0_PWRITE = icn_bus[0].pwrite;
   assign APB_0_PSTRB = icn_bus[0].pstrb;

  // Interface: apb_1
   assign icn_bus[1].prdata =  APB_1_PRDATA;
   assign icn_bus[1].pready =  APB_1_PREADY;
   assign icn_bus[1].pslverr = APB_1_PSLVERR;
   assign APB_1_PADDR = icn_bus[1].paddr;
   assign APB_1_PENABLE = icn_bus[1].penable;
   assign APB_1_PSEL = icn_bus[1].psel;
   assign APB_1_PWDATA = icn_bus[1].pwdata;
   assign APB_1_PWRITE = icn_bus[1].pwrite;
   assign APB_1_PSTRB = icn_bus[1].pstrb;
 
  // Interface: apb_2
  assign icn_bus[2].prdata = APB_2_PRDATA;
  assign icn_bus[2].pready = APB_2_PREADY;
  assign icn_bus[2].pslverr = APB_2_PSLVERR;
  assign APB_2_PADDR = icn_bus[2].paddr;
  assign APB_2_PENABLE = icn_bus[2].penable;
  assign APB_2_PSEL = icn_bus[2].psel;
  assign APB_2_PWDATA = icn_bus[2].pwdata;
  assign APB_2_PWRITE = icn_bus[2].pwrite;
  assign APB_2_PSTRB = icn_bus[2].pstrb;

  // Interface: apb_3
  assign icn_bus[3].prdata = APB_3_PRDATA;
  assign icn_bus[3].pready = APB_3_PREADY;
  assign icn_bus[3].pslverr = APB_3_PSLVERR;
  assign APB_3_PADDR = icn_bus[3].paddr;
  assign APB_3_PENABLE = icn_bus[3].penable;
  assign APB_3_PSEL = icn_bus[3].psel;
  assign APB_3_PWDATA = icn_bus[3].pwdata;
  assign APB_3_PWRITE = icn_bus[3].pwrite;
  assign APB_3_PSTRB = icn_bus[3].pstrb;

  // Interface: apb_4
  assign icn_bus[4].prdata = APB_4_PRDATA;
  assign icn_bus[4].pready = APB_4_PREADY;
  assign icn_bus[4].pslverr = APB_4_PSLVERR;
  assign APB_4_PADDR = icn_bus[4].paddr;
  assign APB_4_PENABLE = icn_bus[4].penable;
  assign APB_4_PSEL = icn_bus[4].psel;
  assign APB_4_PWDATA = icn_bus[4].pwdata;
  assign APB_4_PWRITE = icn_bus[4].pwrite;
  assign APB_4_PSTRB = icn_bus[4].pstrb;

  // Interface: apb_5
  assign icn_bus[5].prdata = APB_5_PRDATA;
  assign icn_bus[5].pready = APB_5_PREADY;
  assign icn_bus[5].pslverr = APB_5_PSLVERR;
  assign APB_5_PADDR = icn_bus[5].paddr;
  assign APB_5_PENABLE = icn_bus[5].penable;
  assign APB_5_PSEL = icn_bus[5].psel;
  assign APB_5_PWDATA = icn_bus[5].pwdata;
  assign APB_5_PWRITE = icn_bus[5].pwrite;
  assign APB_5_PSTRB = icn_bus[5].pstrb;

  // Interface: apb_6
  assign icn_bus[6].prdata = APB_6_PRDATA;
  assign icn_bus[6].pready = APB_6_PREADY;
  assign icn_bus[6].pslverr = APB_6_PSLVERR;
  assign APB_6_PADDR = icn_bus[6].paddr;
  assign APB_6_PENABLE = icn_bus[6].penable;
  assign APB_6_PSEL = icn_bus[6].psel;
  assign APB_6_PWDATA = icn_bus[6].pwdata;
  assign APB_6_PWRITE = icn_bus[6].pwrite;
  assign APB_6_PSTRB = icn_bus[6].pstrb;

  // Interface: apb_7
  assign icn_bus[7].prdata = APB_7_PRDATA;
  assign icn_bus[7].pready = APB_7_PREADY;
  assign icn_bus[7].pslverr = APB_7_PSLVERR;
  assign APB_7_PADDR = icn_bus[7].paddr;
  assign APB_7_PENABLE = icn_bus[7].penable;
  assign APB_7_PSEL = icn_bus[7].psel;
  assign APB_7_PWDATA = icn_bus[7].pwdata;
  assign APB_7_PWRITE = icn_bus[7].pwrite;
  assign APB_7_PSTRB = icn_bus[7].pstrb;

  // Interface: obi
  assign initiator_bus[0].addr = obi_addr;
  assign initiator_bus[0].aid = obi_aid;
  assign initiator_bus[0].be = obi_be;
  assign initiator_bus[0].req = obi_req;
  assign initiator_bus[0].reqpar = obi_reqpar;
  assign initiator_bus[0].rready = obi_rready;
  assign initiator_bus[0].rreadypar = obi_rreadypar;
  assign initiator_bus[0].wdata = obi_wdata;
  assign initiator_bus[0].we = obi_we;

  assign obi_err = initiator_bus[0].err;
  assign obi_gnt = initiator_bus[0].gnt;
  assign obi_gntpar = initiator_bus[0].gntpar;
  assign obi_rdata = initiator_bus[0].rdata;
  assign obi_rid = initiator_bus[0].rid;
  assign obi_rvalid = initiator_bus[0].rvalid;
  assign obi_rvalidpar = initiator_bus[0].rvalidpar;

endmodule
