//=====================================================================
// File   : snake_body_ram.v
// Brief  : Storage for snake body segments (X/Y per segment)
// Note   : Minimal skeleton; single write port, simple readback of head
//=====================================================================
module snake_body_ram #(
  parameter MAX_LEN = 256
)(
  input  wire        clk,
  input  wire        wr_en,
  input  wire [7:0]  x_in,
  input  wire [6:0]  y_in,
  input  wire [7:0]  wr_idx,   // write index (head position)
  output wire [7:0]  head_x,   // readback x at index 0 (example)
  output wire [6:0]  head_y
);
  reg [7:0] xs [0:MAX_LEN-1];
  reg [6:0] ys [0:MAX_LEN-1];

  // Write to circular buffer entry wr_idx
  always @(posedge clk) begin
    if (wr_en) begin
      xs[wr_idx] <= x_in;
      ys[wr_idx] <= y_in;
    end
  end

  // For a minimal skeleton, expose entry 0 as "head"
  assign head_x = xs[0];
  assign head_y = ys[0];
endmodule