wcfg new

wave add /TOP_TB/dut/clk_p_i
wave add /TOP_TB/dut/sysclk
wave add /TOP_TB/dut/reset
divider add "Clocking"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/MGTREFCLKTX_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXOUTCLK_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXUSRCLK2_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/GTXTXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXRESETDONE_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/PLLRXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXPLLLKDET_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXRESETDONE_OUT
divider add "TX Data"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXCHARISK_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXDATA_IN -radix hex
divider add "RX Data"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXDATA_OUT -radix hex
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXCHARISK_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXDISPERR_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXNOTINTABLE_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXBYTEISALIGNED_OUT
divider add "APP TX"
wave add /TOP_TB/dut/tx_data -radix hex
wave add /TOP_TB/dut/tx_isk
wave add /TOP_TB/dut/ready
divider add "APP RX"
wave add /TOP_TB/dut/rx_data -radix hex
wave add /TOP_TB/dut/rx_isk
wave add /TOP_TB/dut/rx_data_bound -radix hex
wave add /TOP_TB/dut/rx_isk_bound
wave add /TOP_TB/dut/errors
wave add /TOP_TB/dut/finish
wave add /TOP_TB/dut/loop_i/rx_cycles_o -radix unsigned
wave add /TOP_TB/leds

run 100 us
quit
