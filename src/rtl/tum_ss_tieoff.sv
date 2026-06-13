/*
  Contributors:
    * Matti Käyrä (matti.kayra@tuni.fi)
  Description:
    * integration tieoff
*/

module tum_ss(
    // Interface: APB
    input  logic [31:0] PADDR,
    input  logic        PENABLE,
    input  logic        PSEL,
    input  logic [31:0] PWDATA,
    input  logic        PWRITE,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR,

    // Interface: Clock
    input  logic        clk_in,

    // Interface: high_speed_clock
    input  logic        high_speed_clk,

    // Interface: IRQ
    output logic        irq_3,

    // Interface: Reset
    input  logic        reset_int,

    // Interface: SS_Ctrl
    input  logic        irq_en_3,
    input  logic [7:0]  ss_ctrl_3,
    
    //Interface: GPIO pmod 
    input  logic [15:0]  pmod_gpi,
    output logic [15:0]  pmod_gpo,
    output logic [15:0]  pmod_gpio_oe

);

// WARNING: EVERYTHING ON AND ABOVE THIS LINE MAY BE OVERWRITTEN BY KACTUS2!!!

  // Group5 systolic-array AI accelerator integration.
  //
  // Reset polarity note: the SoC delivers an active-low functional reset on
  // reset_int, while accelerator_top expects an active-high reset_int
  // (it derives rst_n = ~reset_int internally). Invert here to match.
  //
  // The PMOD GPIO interface is unused by this accelerator; drive it inactive.
  assign pmod_gpo     = 'h0;
  assign pmod_gpio_oe = 'h0;

  // Physical systolic-array dimension (M = N = K). Override at synthesis time
  // with +define+ACCEL_DIM=8 (e.g. `ACCEL_DIM=8 make all_xilinx`) to fit smaller
  // FPGAs such as the PYNQ-Z1; defaults to 16 to match the standalone testbench
  // and the Python golden model. Runtime matrix dims written via the APB regmap
  // must stay <= this physical size.
`ifndef ACCEL_DIM
  `define ACCEL_DIM 16
`endif

  // Element bit-width. INT8 is the baseline (matches the Python golden
  // generator and the regenerated accel_gemm_data.h). Override at compile time
  // with +define+ACCEL_DATA_W=16 (Verilator: -DACCEL_DATA_W=16) for a wider
  // datapath; the firmware test header must be regenerated to match.
`ifndef ACCEL_DATA_W
  `define ACCEL_DATA_W 8
`endif

  accelerator_top #(
    .DATA_W (`ACCEL_DATA_W),
    .M      (`ACCEL_DIM),
    .N      (`ACCEL_DIM),
    .K      (`ACCEL_DIM)
  ) i_accelerator_top (
    // Clock / reset
    .clk_in    (clk_in),
    .reset_int (~reset_int),    // SoC reset_int is active-low; accel wants active-high

    // APB subordinate (accelerator uses APB_AW=10 of the 4 KiB window)
    .PADDR     (PADDR[9:0]),
    .PSEL      (PSEL),
    .PENABLE   (PENABLE),
    .PWRITE    (PWRITE),
    .PWDATA    (PWDATA),
    .PRDATA    (PRDATA),
    .PREADY    (PREADY),
    .PSLVERR   (PSLVERR),

    // SoC interrupt / subsystem control
    .irq_en_4  (irq_en_3),
    .ss_ctrl_4 (ss_ctrl_3),
    .irq_4     (irq_3)
  );

endmodule
