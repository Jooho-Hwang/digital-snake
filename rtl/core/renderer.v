//=====================================================================
// File   : renderer.v
// Brief  : Live (frameless) renderer: grid XY -> RGB
// Notes  : Minimal look: green field, blue border.
//          Hook snake/apple overlays in future revisions.
//=====================================================================
`include "rtl/infra/defs.vh"

module renderer (
  input  wire                      clk,
  input  wire                      pix_en,
  input  wire                      de,
  input  wire [7:0]                gx,
  input  wire [6:0]                gy,
  output reg  [`VGA_RGB_WIDTH-1:0] rgb
);
  // Simple palette: {R,G,B} each 1 bit
  localparam [2:0] COL_BG   = 3'b010; // green
  localparam [2:0] COL_EDGE = 3'b001; // blue
  localparam [2:0] COL_BLK  = 3'b000; // black

  // Border thresholds from grid size
  localparam [7:0] X_MIN = 8'd0;
  localparam [7:0] X_MAX = (`GRID_COLS-1);
  localparam [6:0] Y_MIN = 7'd0;
  localparam [6:0] Y_MAX = (`GRID_ROWS-1);

  always @(posedge clk) if (pix_en) begin
    if (!de) begin
      rgb <= COL_BLK;
    end else if (gx==X_MIN || gx==X_MAX || gy==Y_MIN || gy==Y_MAX) begin
      rgb <= COL_EDGE;
    end else begin
      rgb <= COL_BG;
    end
  end
endmodule