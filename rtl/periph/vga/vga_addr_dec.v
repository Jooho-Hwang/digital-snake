//=====================================================================
// File   : vga_addr_dec.v
// Brief  : Convert pixel counters to coarse grid coordinates (gx, gy)
//          using CELL_PX scaling; outputs valid only when 'de' is high
//=====================================================================
`include "rtl/infra/defs.vh"

module vga_addr_dec (
  input  wire       de,                 // visible area
  input  wire [9:0] hcount,             // pixel X
  input  wire [9:0] vcount,             // pixel Y
  output wire [7:0] gx,                 // grid X (0..GRID_COLS-1)
  output wire [6:0] gy                  // grid Y (0..GRID_ROWS-1)
);
  // Integer divide by CELL_PX to downscale into grid cells
  assign gx = de ? (hcount / `CELL_PX)[7:0] : 8'd0;
  assign gy = de ? (vcount / `CELL_PX)[6:0] : 7'd0;
endmodule