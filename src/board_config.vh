//=====================================================================
// File   : board_config.vh
// Brief  : Board-specific configuration parameters for digital snake
//=====================================================================
`ifndef BOARD_CONFIG_VH
`define BOARD_CONFIG_VH

// System clock frequency in Hz (adjust to your board)
`define CLK_FREQ_HZ 50000000

// VGA RGB bus width (R,G,B each 1-bit)
`define VGA_RGB_WIDTH 3

// Active level for push buttons (1 = active-high)
`define BTN_ACTIVE_HIGH 1

`endif