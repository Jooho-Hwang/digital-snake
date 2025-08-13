//=====================================================================
// File   : tb_vga_timing.v
// Brief  : Smoke test for VGA timing generator
//          - Drives clk/rst/pix_en
//          - Observes hsync/vsync/de/hcount/vcount
//=====================================================================
`include "sim_common.vh"

module tb_vga_timing;

  // Clock & reset
  reg clk = 1'b0;
  reg rst = 1'b1;
  always #(`TCLK_NS/2) clk = ~clk;

  // Pixel enable (always step for this smoke test)
  reg pix_en = 1'b0;

  // DUT outputs
  wire       hsync, vsync, de;
  wire [9:0] hcount, vcount;

  // DUT
  vga_timing dut (
    .clk   (clk),
    .rst   (rst),
    .pix_en(pix_en),
    .hsync (hsync),
    .vsync (vsync),
    .de    (de),
    .hcount(hcount),
    .vcount(vcount)
  );

  // Stimulus
  initial begin
    // Deassert reset
    repeat (5) @(posedge clk);
    rst <= 1'b0;

    // Drive pixel enable as a 1-cycle strobe every clock
    forever begin
      @(posedge clk);
      pix_en <= 1'b1;
      @(posedge clk);
      pix_en <= 1'b0;
    end
  end

  // Stop after some frames
  initial begin
    // Run long enough to wrap several lines & at least one frame
    #(16_000_000); // ~16 ms sim time
    $finish;
  end

endmodule