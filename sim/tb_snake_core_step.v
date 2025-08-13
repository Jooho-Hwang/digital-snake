//=====================================================================
// File   : tb_snake_core_step.v
// Brief  : Minimal step test for snake_core
//          - Generates sparse game_en pulses
//          - Wiggles direction inputs
//=====================================================================
`include "sim_common.vh"

module tb_snake_core_step;

  // Clock & reset
  reg clk = 1'b0;
  reg rst = 1'b1;
  always #(`TCLK_NS/2) clk = ~clk;

  // Stimuli
  reg       game_en = 1'b0;
  reg [1:0] dir     = 2'b00;

  // DUT
  snake_core dut (
    .clk    (clk),
    .rst    (rst),
    .game_en(game_en),
    .dir    (dir)
  );

  // Basic sequence
  initial begin
    // Reset
    repeat (5) @(posedge clk);
    rst <= 1'b0;

    // Idle a bit
    repeat (10) @(posedge clk);

    // Step right for a few ticks
    dir <= 2'b10;
    repeat (8) begin
      @(posedge clk); game_en <= 1'b1;
      @(posedge clk); game_en <= 1'b0;
      repeat (5) @(posedge clk);
    end

    // Step left for a few ticks
    dir <= 2'b01;
    repeat (6) begin
      @(posedge clk); game_en <= 1'b1;
      @(posedge clk); game_en <= 1'b0;
      repeat (4) @(posedge clk);
    end

    // Done
    repeat (20) @(posedge clk);
    $finish;
  end

endmodule