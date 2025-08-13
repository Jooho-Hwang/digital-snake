//=====================================================================
// File   : defs.vh
// Brief  : Common project-wide constants (clock, VGA, grid, game tick)
// Note   : Included by top and submodules
//=====================================================================
`ifndef DEFS_VH
`define DEFS_VH

//----------------------------------------------------------------------
// Clock
//----------------------------------------------------------------------
// If not set by board_config.vh, default to 50 MHz
`ifndef CLK_FREQ_HZ
  `define CLK_FREQ_HZ 50000000
`endif

//----------------------------------------------------------------------
// VGA 640x480@60 timing (pixel enable based stepping)
//----------------------------------------------------------------------
`define H_VISIBLE 640
`define H_FRONT   16
`define H_SYNC    96
`define H_BACK    48
`define H_TOTAL  (`H_VISIBLE + `H_FRONT + `H_SYNC + `H_BACK)

`define V_VISIBLE 480
`define V_FRONT   10
`define V_SYNC     2
`define V_BACK    33
`define V_TOTAL  (`V_VISIBLE + `V_FRONT + `V_SYNC + `V_BACK)

//----------------------------------------------------------------------
// Grid scaling (CELL_PX pixels per cell). Example: 640x480 / 4 = 160x120
//----------------------------------------------------------------------
`define CELL_PX    4
`define GRID_COLS (`H_VISIBLE/`CELL_PX)   // 160
`define GRID_ROWS (`V_VISIBLE/`CELL_PX)   // 120

//----------------------------------------------------------------------
// Game tick period (milliseconds)
//----------------------------------------------------------------------
`define GAME_TICK_MS 100

//----------------------------------------------------------------------
// RGB width (R,G,B 1-bit each unless overridden)
//----------------------------------------------------------------------
`ifndef VGA_RGB_WIDTH
  `define VGA_RGB_WIDTH 3
`endif

`endif // DEFS_VH