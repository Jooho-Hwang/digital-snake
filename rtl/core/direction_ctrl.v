//=====================================================================
// File   : direction_ctrl.v
// Brief  : Direction state from debounced button inputs
// Notes  : Minimal logic; forbid immediate reverse can be added later
//=====================================================================
module direction_ctrl (
  input  wire clk,
  input  wire rst,
  input  wire left,
  input  wire right,
  input  wire up,
  input  wire down,
  output reg  [1:0] dir   // 2'b00:none, 01:left, 10:right, 11:up/down
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dir <= 2'b00;
    end else begin
      if (left)       dir <= 2'b01;
      else if (right) dir <= 2'b10;
      else if (up|down) dir <= 2'b11;
    end
  end
endmodule