# ----------------------------------------------------------------------------
# LVDS 200 MHz oscillator (DSC1123) at U49 - BANK 34 (VCCO_HP: 1.5/1.8v @ J19)
# ----------------------------------------------------------------------------


set_property PACKAGE_PIN G7 [get_ports sysclk_p_i]
set_property PACKAGE_PIN F7 [get_ports sysclk_n_i]
#set_property IOSTANDARD LVDS [get_ports sysclk_p_i]
#set_property IOSTANDARD LVDS [get_ports sysclk_n_i]

# ----------------------------------------------------------------------------
# 8 x Digital (isolated) IOs - BANK 13 (VCCO_HR: VADJ)
# ----------------------------------------------------------------------------


set_property PACKAGE_PIN AD26  [get_ports {leds_o[0]}]
set_property PACKAGE_PIN AE26  [get_ports {leds_o[1]}]
set_property PACKAGE_PIN AD25  [get_ports {leds_o[2]}]
set_property PACKAGE_PIN AE25  [get_ports {leds_o[3]}]

set_property IOSTANDARD LVTTL [get_ports {leds_o[0]}]
set_property IOSTANDARD LVTTL [get_ports {leds_o[1]}]
set_property IOSTANDARD LVTTL [get_ports {leds_o[2]}]
set_property IOSTANDARD LVTTL [get_ports {leds_o[3]}]
