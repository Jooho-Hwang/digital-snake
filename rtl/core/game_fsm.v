//=====================================================================
// File   : game_fsm.v
// Brief  : Simple game state machine for Digital Snake
// States : IDLE -> RUN -> PAUSE <-> RUN -> DEAD -> IDLE
// Clock  : clk
// Reset  : Synchronous, active-high (rst)
//=====================================================================
module game_fsm (
  input  wire clk,
  input  wire rst,
  input  wire start_btn,
  input  wire pause_btn,
  input  wire dead_in,
  output reg  [1:0] state    // 0:IDLE, 1:RUN, 2:PAUSE, 3:DEAD
);
  localparam IDLE  = 2'd0;
  localparam RUN   = 2'd1;
  localparam PAUSE = 2'd2;
  localparam DEAD  = 2'd3;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE : state <= start_btn ? RUN  : IDLE;
        RUN  : state <= dead_in   ? DEAD : (pause_btn ? PAUSE : RUN);
        PAUSE: state <= pause_btn ? RUN  : PAUSE;
        DEAD : state <= start_btn ? IDLE : DEAD;
        default: state <= IDLE;
      endcase
    end
  end
endmodule