//=====================================================================
// File   : apple_gen_lfsr.v
// Brief  : LFSR-based apple coordinate generator (pseudo-random)
// Clock  : clk
// Reset  : Synchronous, active-high (rst)
// Note   : 'tick' should be asserted when a new coordinate is needed
//=====================================================================
module apple_gen_lfsr (
  input  wire clk,
  input  wire rst,
  input  wire tick,
  output reg  [7:0] ax,
  output reg  [6:0] ay
);
  // 16-bit LFSR (x^16 + x^14 + x^13 + x^11 + 1)
  reg [15:0] lfsr;
  wire fb = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      lfsr <= 16'hACE1;
    end else if (tick) begin
      lfsr <= {lfsr[14:0], fb};
    end
  end

  // Map to 8-bit X / 7-bit Y; caller may clamp/modulo to grid size
  always @* begin
    ax = lfsr[7:0];
    ay = lfsr[14:8];
  end
endmodule