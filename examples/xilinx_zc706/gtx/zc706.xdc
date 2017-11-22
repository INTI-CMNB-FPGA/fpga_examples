create_clock -period 5.0 [get_ports sys_clk_n_i]
create_clock -period 5.0 [get_ports sma_clk_n_i]
create_clock -name usr_clk -period 6.4 [get_ports usr_clk_p_i]

# SYSCLK = 200 MHz (LVDS)
set_property PACKAGE_PIN H9     [get_ports sys_clk_p_i]
set_property PACKAGE_PIN G9     [get_ports sys_clk_n_i]
set_property IOSTANDARD LVDS    [get_ports sys_clk_p_i]
set_property IOSTANDARD LVDS    [get_ports sys_clk_n_i]

# USRCLK = 156.250 MHz (LVDS_25)
set_property PACKAGE_PIN AF14   [get_ports usr_clk_p_i]
set_property PACKAGE_PIN AG14   [get_ports usr_clk_n_i]
set_property IOSTANDARD LVDS_25 [get_ports usr_clk_p_i]
set_property IOSTANDARD LVDS_25 [get_ports usr_clk_n_i]

# SMA_MGT_REFCLK
set_property PACKAGE_PIN W8     [get_ports sma_clk_p_i]
set_property PACKAGE_PIN W7     [get_ports sma_clk_n_i]

set_property LOC GTXE2_CHANNEL_X0Y11 [get_cells gbt_i/gbt1_i/gbt1_init_i/U0/gbt1_i/gt0_gbt1_i/gtxe2_i]

# GPIO_LED_LEFT
set_property PACKAGE_PIN Y21     [get_ports led_o]
set_property IOSTANDARD LVCMOS25 [get_ports led_o]

set_property SEVERITY WARNING [get_drc_checks REQP-56]
