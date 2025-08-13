//=====================================================================
// File   : debounce.v
// Brief  : Simple debounce using enable-sampled shift register
// Clock  : clk
// Reset  : Synchronous, active-high (rst)
// Notes  : 'en' should be a slow sampling strobe (e.g., ~5 ms period)
//=====================================================================
module debounce (
  input  wire clk,
  input  wire en,    // sampling enable (one cycle pulse, slow)
  input  wire rst,   // sync reset
  input  wire din,   // raw button
  output reg  dout   // debounced button
);
  reg [2:0] sh;

  always @(posedge clk) begin
    if (rst) begin
      sh   <= 3'b000;
      dout <= 1'b0;
    end else if (en) begin
      sh   <= {sh[1:0], din};
      dout <= (sh == 3'b111);   // stable '1' for 3 samples
    end
  end
endmodule