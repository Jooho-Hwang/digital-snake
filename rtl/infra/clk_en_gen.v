//=====================================================================
// File   : clk_en_gen.v
// Brief  : Generate periodic enable pulses for pixel, game tick, debounce
// Clock  : clk (system clock)
// Reset  : Synchronous, active-high (rst)
// Ports  : pix_en      - one-cycle pulse for pixel stepping
//          game_en     - one-cycle pulse per GAME_TICK_MS
//          debounce_en - one-cycle pulse for button sampling
//=====================================================================
`include "rtl/infra/defs.vh"

module clk_en_gen (
  input  wire clk,
  input  wire rst,
  output reg  pix_en,
  output reg  game_en,
  output reg  debounce_en
);
  // ------------------------------------------------------------------
  // Dividers
  // - PIX_DIV: coarse divider for pixel stepping (tune per board)
  // - GAME_DIV: CLK_FREQ_HZ * GAME_TICK_MS / 1000
  // - DB_DIV: debounce sampling every ~5 ms
  // ------------------------------------------------------------------
  localparam integer PIX_DIV  = 2;
  localparam integer GAME_DIV = (`CLK_FREQ_HZ/1000) * `GAME_TICK_MS;
  localparam integer DB_DIV   = (`CLK_FREQ_HZ/1000) * 5;

  // Counters sized to cover 0..N-1
  localparam integer C_W_PIX  = (PIX_DIV  <= 1) ? 1 : $clog2(PIX_DIV);
  localparam integer C_W_GAME = (GAME_DIV <= 1) ? 1 : $clog2(GAME_DIV);
  localparam integer C_W_DB   = (DB_DIV   <= 1) ? 1 : $clog2(DB_DIV);

  reg [C_W_PIX-1:0]  pix_cnt;
  reg [C_W_GAME-1:0] game_cnt;
  reg [C_W_DB-1:0]   db_cnt;

  // ------------------------------------------------------------------
  // Pixel enable
  // ------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pix_cnt <= {C_W_PIX{1'b0}};
      pix_en  <= 1'b0;
    end else begin
      pix_cnt <= (pix_cnt == PIX_DIV-1) ? {C_W_PIX{1'b0}} : pix_cnt + {{C_W_PIX-1{1'b0}},1'b1};
      pix_en  <= (pix_cnt == {C_W_PIX{1'b0}});
    end
  end

  // ------------------------------------------------------------------
  // Game tick enable
  // ------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      game_cnt <= {C_W_GAME{1'b0}};
      game_en  <= 1'b0;
    end else begin
      game_en  <= (game_cnt == {C_W_GAME{1'b0}});
      game_cnt <= (game_cnt == GAME_DIV-1) ? {C_W_GAME{1'b0}} : game_cnt + {{C_W_GAME-1{1'b0}},1'b1};
    end
  end

  // ------------------------------------------------------------------
  // Debounce sampling enable
  // ------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      db_cnt      <= {C_W_DB{1'b0}};
      debounce_en <= 1'b0;
    end else begin
      debounce_en <= (db_cnt == {C_W_DB{1'b0}});
      db_cnt      <= (db_cnt == DB_DIV-1) ? {C_W_DB{1'b0}} : db_cnt + {{C_W_DB-1{1'b0}},1'b1};
    end
  end

endmodule