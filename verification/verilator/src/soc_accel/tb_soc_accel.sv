// -----------------------------------------------------------------------------
// tb_soc_accel.sv -- Full-SoC functional test that drives the group5 systolic-
// array accelerator through the real OBI/APB fabric.
//
// Unlike the standalone tb_accel (which pokes the accelerator's APB slave
// directly), this testbench instantiates the complete `Didactic` SoC and lets
// the Ibex core execute the baremetal program sw/accel/accel.c. That program
// streams Matrix A/B over the system bus, starts the compute, polls STATUS,
// reads Matrix C back and writes a result word (accel_result) into data memory.
//
// License-free: runs under open-source Verilator (no QuestaSim / Mentor
// license needed).
//
// Boot bring-up WITHOUT JTAG
// --------------------------
//   * The Ibex fetch-enable register (SS_Ctrl) resets to 0x5 == MuBi "On", so
//     the core starts fetching automatically on reset.
//   * The hardcoded boot address is 0x0104_0100, so the reset vector is
//     0x0104_0180 inside the SS_Ctrl "boot ROM" register `boot_reg_0`. In the
//     real flow a debugger writes a jump there over JTAG; here we emulate that
//     by forcing boot_reg_0 to `jal x0, 0x0100_0080` (= 0xF01BF06F), i.e. jump
//     to the imem reset vector, which then branches to reset_handler -> main.
//   * The program image is pre-loaded into the instruction SRAM via $readmemh,
//     exactly mirroring what the JTAG `load_L2` routine does word by word.
//
// SoC address map (TARGET_SIZE = 0x1_0000):
//   imem  0x0100_0000 | dmem 0x0101_0000 | ctrl 0x0104_0000 | accel 0x0105_1000
//
// PASS criterion: accel.c writes accel_result (dmem word 0) = 0xACCE5500.
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module tb_soc_accel;

    // Reset vector boot-ROM jump: `jal x0, (0x0100_0080 - 0x0104_0180)`.
    localparam logic [31:0] BOOT_JUMP = 32'hF01BF06F;
    // accel.c result sink (dmem word 0 == 0x0101_0000).
    localparam logic [31:0] RESULT_PASS = 32'hACCE5500;
    localparam logic [31:0] RESULT_FAIL = 32'hBADD0000;

    // -------------------------------------------------------------------------
    // Clock / reset (reset is active-low on the SoC pad).
    // -------------------------------------------------------------------------
    logic clk   = 1'b0;
    logic rst_n = 1'b0;
    always #5 clk = ~clk; // 100 MHz

    // -------------------------------------------------------------------------
    // SoC pads. clk_in / reset are inout; drive them from the TB. JTAG is tied
    // off (trst asserted low) so the debug module stays inactive and never
    // halts the core. Other pads float on local tri nets.
    // -------------------------------------------------------------------------
    tri        clk_in_w;
    tri        reset_w;
    wire [15:0] gpio_w;
    tri        jtag_tck_w;
    tri        jtag_tdi_w;
    tri        jtag_tdo_w;
    tri        jtag_tms_w;
    tri        jtag_trst_w;
    wire [1:0] spi_csn_w;
    wire [3:0] spi_data_w;
    wire       spi_sck_w;
    tri        uart_rx_w;
    wire       uart_tx_w;

    // Drive the bidirectional pads from the TB. JTAG is tied off (trst asserted
    // low) so the debug module stays inactive and never halts the core.
    assign clk_in_w    = clk;
    assign reset_w     = rst_n;
    assign jtag_tck_w  = 1'b0;
    assign jtag_tdi_w  = 1'b0;
    assign jtag_tms_w  = 1'b1;
    assign jtag_trst_w = 1'b0;
    assign uart_rx_w   = 1'b1; // idle-high

    Didactic dut (
        .clk_in    (clk_in_w),
        .gpio      (gpio_w),
        .jtag_tck  (jtag_tck_w),
        .jtag_tdi  (jtag_tdi_w),
        .jtag_tdo  (jtag_tdo_w),
        .jtag_tms  (jtag_tms_w),
        .jtag_trst (jtag_trst_w),
        .reset     (reset_w),
        .spi_csn   (spi_csn_w),
        .spi_data  (spi_data_w),
        .spi_sck   (spi_sck_w),
        .uart_rx   (uart_rx_w),
        .uart_tx   (uart_tx_w)
    );

    // -------------------------------------------------------------------------
    // Hierarchical handles into the SoC.
    // -------------------------------------------------------------------------
    `define IMEM dut.SystemControl_SS.SysCtrl_SS.i_imem.ram
    `define DMEM dut.SystemControl_SS.SysCtrl_SS.i_dmem.ram
    `define BOOTREG dut.SystemControl_SS.SysCtrl_SS.ctrl_reg_array.boot_reg_0

    // -------------------------------------------------------------------------
    // Pre-load the program image and force the boot-ROM jump.
    // NOTE: i_imem's own initial block zero-fills `ram` at time 0 when its
    // INIT_FILE parameter is empty.  Loading the program here in another time-0
    // initial races with that zero-fill, so the actual $readmemh is deferred
    // into the reset window (see stimulus block below).
    // -------------------------------------------------------------------------
    string hexfile;
    logic [31:0] prog_tmp [0:4095];
    integer wi;
    initial begin
        if (!$value$plusargs("HEX=%s", hexfile))
            hexfile = "accel.hex";
        // Emulate the debugger-installed boot vector for the whole run.
        force `BOOTREG = BOOT_JUMP;
    end

    // -------------------------------------------------------------------------
    // Stimulus: release reset, then watch the result sink in data memory.
    // -------------------------------------------------------------------------
    localparam int unsigned TIMEOUT_CYCLES = 2000000;
    // Outcome: 0 = still running, 1 = pass, 2 = mismatch, 3 = timeout.
    logic [31:0] res;
    integer cyc;
    int unsigned outcome;

    initial begin
        rst_n = 1'b0;
        // Load the program after i_imem's time-0 zero-fill has completed.
        repeat (3) @(posedge clk);
        // The SysCtrl OBI crossbar forwards the full byte address to i_imem and
        // sp_sram indexes `ram` directly with addr_i[11:0] (a byte address used
        // as a word index).  Reads and writes are therefore self-consistent in
        // hardware, but a flat $readmemh into `ram` (ram[i]=word_i) does NOT
        // match: program word i lives at byte 4*i, i.e. ram index 4*i.  Load a
        // contiguous image into a temporary and scatter it accordingly.
        for (wi = 0; wi < 4096; wi = wi + 1)
            prog_tmp[wi] = 32'h0;
        $readmemh(hexfile, prog_tmp);
        for (wi = 0; wi < 1024; wi = wi + 1)
            `IMEM[wi*4] = prog_tmp[wi];
        $display("[tb_soc_accel] loaded program image '%s' (imem@0x00=%08x imem@0x80=%08x)",
                 hexfile, `IMEM[0], `IMEM[32*4]);
        repeat (20) @(posedge clk);
        rst_n = 1'b1;
        $display("[tb_soc_accel] reset released, core booting...");

        res     = '0;
        outcome = 0;
        for (cyc = 0; cyc < TIMEOUT_CYCLES; cyc = cyc + 1) begin
            @(posedge clk);
            res = `DMEM[0];
            if (res === RESULT_PASS) begin
                outcome = 1;
                break;
            end
            if ((res & 32'hFFFF_0000) === RESULT_FAIL) begin
                outcome = 2;
                break;
            end
        end
        if (outcome == 0)
            outcome = 3;

        $display("[tb_soc_accel] accel_result = %08x", res);
        case (outcome)
            1: begin
                $display("[tb_soc_accel] RESULT: PASS (core drove A/B, compute, read C over the bus)");
                $finish;
            end
            2: begin
                $display("[tb_soc_accel] RESULT: FAIL (accelerator result mismatch, mismatches=%0d)",
                         res & 32'hFFFF);
                $fatal(1, "accelerator mismatch");
            end
            default: begin
                $display("[tb_soc_accel] RESULT: FAIL (timeout after %0d cycles, result word never set)",
                         TIMEOUT_CYCLES);
                $fatal(1, "timeout");
            end
        endcase
    end

endmodule
