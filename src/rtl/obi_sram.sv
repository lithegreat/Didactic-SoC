// Description: SRAM with OBI connection

module obi_sram #(
  parameter int unsigned DATA_WIDTH = 64,
  parameter int unsigned NUM_WORDS  = 1024,
  localparam             ADDR_WIDTH = ($clog2(NUM_WORDS) + $clog2((DATA_WIDTH+7)/8))
)(
  input  logic                    clk_i,
  input  logic                    rst_ni,

  input  logic                    req_i,
  input  logic                    we_i,
  input  logic                    rready_i,
  input  logic [  ADDR_WIDTH-1:0] addr_i,     // byte address
  input  logic [  DATA_WIDTH-1:0] wdata_i,
  input  logic [DATA_WIDTH/8-1:0] be_i,
  output logic [  DATA_WIDTH-1:0] rdata_o,
  output logic                    rvalid_o,
  output logic                    rvalidpar_o,
  output logic                    gnt_o,
  output logic                    gntpar_o
);


  /******** PARITY *****************/
  logic rvalid_reg;
  logic gnt_reg;
  assign rvalid_o = rvalid_reg;
  assign rvalidpar_o = ~rvalid_reg;
  assign gnt_o = gnt_reg;
  assign gntpar_o = ~gnt_reg;

  /******* handshaking ********/

  always_ff @( posedge clk_i or negedge rst_ni )
  begin : control_register_ff
    if (~rst_ni) begin
      gnt_reg <= 1'b1;
      rvalid_reg <= 1'b0;
    end
    else begin
      if(req_i & gnt_reg) begin
        gnt_reg <= 1'b0;
        rvalid_reg <= 1'b1;
      end
      else if(~rready_i & ~gnt_reg) begin
        rvalid_reg <= 1'b1;
      end
      else begin
        gnt_reg <= 1'b1;
        rvalid_reg <= 1'b0;
      end
    end
  end //ff

  /******* memory instance ********/

  tc_sram #(
    .NumWords(NUM_WORDS),
    .DataWidth(DATA_WIDTH),
    .ByteWidth(8),
    .NumPorts(1),
    .Latency(1),
    .SimInit("none"),
    .PrintSimCfg(1'b0)
  ) u_tc_sram (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .req_i({req_i}),
    .we_i({we_i}),
    .addr_i({addr_i[ADDR_WIDTH-1:$clog2((DATA_WIDTH+7)/8)]}),  // convert byte to word address
    .wdata_i({wdata_i}),
    .be_i({be_i}),
    .rdata_o(rdata_o)
  );

endmodule
