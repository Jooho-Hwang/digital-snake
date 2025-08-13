//=====================================================================
// File   : sync_2ff.v
// Brief  : 2-stage input synchronizer for single-bit asynchronous signals
// Clock  : clk
// Reset  : none (recommended for metastability filtering)
//=====================================================================
module sync_2ff (
  input  wire clk,
  input  wire d,     // async input
  output reg  q      // synced output
);
  reg q1;
  always @(posedge clk) begin
    q1 <= d;
    q  <= q1;
  end
endmodule