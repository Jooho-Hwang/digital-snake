//=====================================================================
// File   : top_digital_snake.v
// Brief  : Top-level integration for Digital Snake game
//          - Generates enables, handles input, VGA timing, rendering
// Clock  : clk (system clock, e.g., 50 MHz)
// Reset  : Synchronous, active-high (rst)
//=====================================================================

`include "board_config.vh"
`include "rtl/infra/defs.vh"

module top_digital_snake (
  input  wire                       clk,      // system clock
  input  wire                       rst_n,    // active-low reset from board
  input  wire [3:0]                 btn,      // {LEFT, RIGHT, UP, DOWN}
  output wire                       vga_hs,   // VGA HSync
  output wire                       vga_vs,   // VGA VSync
  output wire [`VGA_RGB_WIDTH-1:0]  vga_rgb   // VGA RGB output
);

  //-------------------------------------------------------------------
  // Internal reset signal
  //-------------------------------------------------------------------
  wire rst = ~rst_n;

  //-------------------------------------------------------------------
  // Enable pulses
  //-------------------------------------------------------------------
  wire pix_en;     // pixel clock enable
  wire game_en;    // game tick enable
  wire db_en;      // debounce sampling enable

  clk_en_gen u_en (
    .clk(clk),
    .rst(rst),
    .pix_en(pix_en),
    .game_en(game_en),
    .debounce_en(db_en)
  );

  //-------------------------------------------------------------------
  // Button synchronization & debouncing
  //-------------------------------------------------------------------
  wire [3:0] btn_sync;
  wire [3:0] btn_db;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : G_BTN
      sync_2ff u_sync (
        .clk(clk),
        .d(btn[i]),
        .q(btn_sync[i])
      );
      debounce u_db (
        .clk(clk),
        .en(db_en),
        .rst(rst),
        .din(btn_sync[i]),
        .dout(btn_db[i])
      );
    end
  endgenerate

  wire left_sig  = btn_db[0];
  wire right_sig = btn_db[1];
  wire up_sig    = btn_db[2];
  wire down_sig  = btn_db[3];

  //-------------------------------------------------------------------
  // VGA timing and grid address decoding
  //-------------------------------------------------------------------
  wire [9:0] hcount, vcount;
  wire       de;
  wire [7:0] gx;
  wire [6:0] gy;

  vga_timing u_tmg (
    .clk(clk),
    .rst(rst),
    .pix_en(pix_en),
    .hsync(vga_hs),
    .vsync(vga_vs),
    .de(de),
    .hcount(hcount),
    .vcount(vcount)
  );

  vga_addr_dec u_addr (
    .de(de),
    .hcount(hcount),
    .vcount(vcount),
    .gx(gx),
    .gy(gy)
  );

  //-------------------------------------------------------------------
  // Direction control and core game logic
  //-------------------------------------------------------------------
  wire [1:0] dir;

  direction_ctrl u_dir (
    .clk(clk),
    .rst(rst),
    .left(left_sig),
    .right(right_sig),
    .up(up_sig),
    .down(down_sig),
    .dir(dir)
  );

  snake_core u_core (
    .clk(clk),
    .rst(rst),
    .game_en(game_en),
    .dir(dir)
    // TODO: add coordinate and game state outputs for renderer
  );

  //-------------------------------------------------------------------
  // Renderer and RGB output
  //-------------------------------------------------------------------
  wire [`VGA_RGB_WIDTH-1:0] rgb_core;
  wire [`VGA_RGB_WIDTH-1:0] rgb_out;

  renderer u_ren (
    .clk(clk),
    .pix_en(pix_en),
    .de(de),
    .gx(gx),
    .gy(gy),
    .rgb(rgb_core)
  );

  vga_rgb_out u_rgb (
    .active(de),
    .rgb_in(rgb_core),
    .rgb_out(rgb_out)
  );

  assign vga_rgb = rgb_out;

endmodule