//=====================================================================
// File   : grid_params.vh
// Brief  : Grid-related parameters (overrides/aliases for defs.vh)
// Note   : Include after defs.vh if you want to override defaults
//=====================================================================
`ifndef GRID_PARAMS_VH
`define GRID_PARAMS_VH

`include "rtl/infra/defs.vh"

// Example overrides (uncomment to change from defs.vh)
// `undef  CELL_PX
// `define CELL_PX    4
// `undef  GRID_COLS
// `define GRID_COLS (`H_VISIBLE/`CELL_PX)
// `undef  GRID_ROWS
// `define GRID_ROWS (`V_VISIBLE/`CELL_PX)

`endif // GRID_PARAMS_VH