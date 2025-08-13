//=====================================================================
// File   : collision_check.v
// Brief  : Wall collision detector (borders of grid)
// Note   : Self/body/apple collisions can be added later
//=====================================================================
`include "rtl/infra/defs.vh"

module collision_check (
  input  wire [7:0] head_x,
  input  wire [6:0] head_y,
  output wire       hit_wall
);
  // Grid boundary for 160x120 (derived from defs.vh)
  localparam [7:0] X_MIN = 8'd0;
  localparam [7:0] X_MAX = (`GRID_COLS-1);
  localparam [6:0] Y_MIN = 7'd0;
  localparam [6:0] Y_MAX = (`GRID_ROWS-1);

  assign hit_wall = (head_x <= X_MIN) || (head_x >= X_MAX) ||
                    (head_y <= Y_MIN) || (head_y >= Y_MAX);
endmodule