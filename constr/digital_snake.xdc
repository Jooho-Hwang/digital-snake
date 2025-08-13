#=====================================================================
# File   : digital_snake.xdc
# Brief  : Constraint template for Digital Snake (Xilinx XDC)
# Note   : Replace <PIN_xxx> with actual board pin names.
#=====================================================================

#----------------------------------------------------------------------
# Clock (example: 50 MHz)
#----------------------------------------------------------------------
set_property PACKAGE_PIN <PIN_CLK> [get_ports clk]
set_property IOSTANDARD LVCMOS33   [get_ports clk]
create_clock -name sys_clk -period 20.000 [get_ports clk]

#----------------------------------------------------------------------
# Reset (active-low rst_n on top)
#----------------------------------------------------------------------
set_property PACKAGE_PIN <PIN_RST_N> [get_ports rst_n]
set_property IOSTANDARD LVCMOS33     [get_ports rst_n]
set_property PULLUP true             [get_ports rst_n]

#----------------------------------------------------------------------
# Push buttons: btn[3:0] = {DOWN, UP, RIGHT, LEFT} or your mapping
#----------------------------------------------------------------------
set_property PACKAGE_PIN <PIN_BTN0> [get_ports {btn[0]}]
set_property PACKAGE_PIN <PIN_BTN1> [get_ports {btn[1]}]
set_property PACKAGE_PIN <PIN_BTN2> [get_ports {btn[2]}]
set_property PACKAGE_PIN <PIN_BTN3> [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS33    [get_ports {btn[*]}]

#----------------------------------------------------------------------
# VGA HSync / VSync
#----------------------------------------------------------------------
set_property PACKAGE_PIN <PIN_HS> [get_ports vga_hs]
set_property PACKAGE_PIN <PIN_VS> [get_ports vga_vs]
set_property IOSTANDARD LVCMOS33  [get_ports {vga_hs vga_vs}]

#----------------------------------------------------------------------
# VGA RGB (1 bit per channel in this minimal design)
#   - Map order to your board's DAC/buffer pins
#----------------------------------------------------------------------
set_property PACKAGE_PIN <PIN_RGB_R> [get_ports {vga_rgb[2]}]
set_property PACKAGE_PIN <PIN_RGB_G> [get_ports {vga_rgb[1]}]
set_property PACKAGE_PIN <PIN_RGB_B> [get_ports {vga_rgb[0]}]
set_property IOSTANDARD LVCMOS33     [get_ports {vga_rgb[*]}]

#----------------------------------------------------------------------
# Timing constraints (optional placeholders)
#----------------------------------------------------------------------
# set_clock_groups -asynchronous -group [get_clocks sys_clk]
# set_input_delay  -clock [get_clocks sys_clk] 2.0  [get_ports {btn[*]}]
# set_output_delay -clock [get_clocks sys_clk] 2.0  [get_ports {vga_*}]