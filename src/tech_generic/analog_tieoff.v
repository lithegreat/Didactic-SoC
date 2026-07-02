module TOPCELL_ISAR_with_padframe (
    input  [3:0] Csel,   // connected to pmod_gpi[3:0]
    input  [3:0] Diff,   // connected to pmod_gpi[7:4]
    input  [6:0] Dummy,  // connected to pmod_gpi[14:8]
    input        ESD1    // connected to pmod_gpi[15]
);

endmodule
