
module prim_generic_clock_gating (
  input  clk_i,
  input  en_i,
  input  test_en_i,
  output clk_o
  );

  tc_clk_gating clk_gate (
    .clk_i(clk_i),
    .en_i(en_i),
    .test_en_i(1'b0),
    .clk_o(clk_o)
  );

endmodule