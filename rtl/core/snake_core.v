//=====================================================================
// File   : snake_core.v
// Brief  : Core game logic (skeleton)
//          - Consumes game tick and direction
//          - Placeholders for movement/collision/growth
// Clock  : clk
// Reset  : Synchronous, active-high (rst)
//=====================================================================
module snake_core (
  input  wire       clk,
  input  wire       rst,
  input  wire       game_en,     // one-cycle game tick
  input  wire [1:0] dir          // direction from controller
  // TODO: expose snake head/body and apple positions to renderer
);
  // Placeholders for future implementation
  // Example registers for head position (not yet used outside)
  reg [7:0] head_x;
  reg [6:0] head_y;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      head_x <= 8'd80;
      head_y <= 7'd60;
    end else if (game_en) begin
      // Minimal motion demo (optional):
      case (dir)
        2'b01: head_x <= head_x - 1'b1; // left
        2'b10: head_x <= head_x + 1'b1; // right
        2'b11: head_y <= head_y ^ 1'b0; // placeholder (no vertical move)
        default: /* no move */;
      endcase
    end
  end
endmodule