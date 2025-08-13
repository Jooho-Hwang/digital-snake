//=====================================================================
// File   : vga_rgb_out.v
// Brief  : Gate RGB by active display region
// Ports  : active  - display enable (DE)
//          rgb_in  - RGB from renderer (width param is global macro)
//          rgb_out - gated RGB to VGA pins
//=====================================================================
`include "rtl/infra/defs.vh"

module vga_rgb_out (
  input  wire                  active,
  input  wire [`VGA_RGB_WIDTH-1:0] rgb_in,
  output wire [`VGA_RGB_WIDTH-1:0] rgb_out
);
  assign rgb_out = active ? rgb_in : {`VGA_RGB_WIDTH{1'b0}};
endmodule