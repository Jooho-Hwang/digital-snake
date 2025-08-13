//=====================================================================
// File   : rising_edge.v
// Brief  : Rising-edge detector (one-cycle pulse on 0->1 transition)
// Clock  : clk
// Reset  : none (pulse is derived from registered history)
//=====================================================================
module rising_edge (
  input  wire clk,
  input  wire d,
  output reg  p   // pulse
);
  reg z;
  always @(posedge clk) begin
    p <= d & ~z;
    z <= d;
  end
endmodule