//=====================================================================
// File   : vga_timing.v
// Brief  : VGA 640x480@60 timing generator using pixel enable stepping
// Clock  : clk (system clock)
// Reset  : Synchronous, active-high (rst)
// Ports  : pix_en  - one-cycle step for pixel timing
//          hsync   - active-low HSync
//          vsync   - active-low VSync
//          de      - data-enable (visible region)
//          hcount  - 0..H_TOTAL-1
//          vcount  - 0..V_TOTAL-1
//=====================================================================
`include "rtl/infra/defs.vh"

module vga_timing (
  input  wire clk,
  input  wire rst,
  input  wire pix_en,
  output reg  hsync,
  output reg  vsync,
  output reg  de,
  output reg [9:0] hcount,
  output reg [9:0] vcount
);

  //-------------------------------------------------------------------
  // Horizontal counter
  //-------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      hcount <= 10'd0;
    end else if (pix_en) begin
      hcount <= (hcount == `H_TOTAL-1) ? 10'd0 : hcount + 10'd1;
    end
  end

  wire line_wrap = (pix_en && (hcount == `H_TOTAL-1));

  //-------------------------------------------------------------------
  // Vertical counter (advance at end of line)
  //-------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      vcount <= 10'd0;
    end else if (line_wrap) begin
      vcount <= (vcount == `V_TOTAL-1) ? 10'd0 : vcount + 10'd1;
    end
  end

  //-------------------------------------------------------------------
  // Sync and DE generation (active-low syncs)
  //-------------------------------------------------------------------
  always @(*) begin
    // DE: visible region
    de = (hcount < `H_VISIBLE) && (vcount < `V_VISIBLE);

    // HSync low during sync interval
    hsync = ~((hcount >= `H_VISIBLE + `H_FRONT) &&
              (hcount <  `H_VISIBLE + `H_FRONT + `H_SYNC));

    // VSync low during sync interval
    vsync = ~((vcount >= `V_VISIBLE + `V_FRONT) &&
              (vcount <  `V_VISIBLE + `V_FRONT + `V_SYNC));
  end

endmodule