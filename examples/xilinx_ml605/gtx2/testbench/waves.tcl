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
wave add /TOP_TB/dut/loop_i/tx_state
wave add /TOP_TB/dut/loop_i/tx_data_o -radix hex
wave add /TOP_TB/dut/loop_i/tx_isk_o
wave add /TOP_TB/dut/loop_i/tx_ready_i
wave add /TOP_TB/dut/loop_i/tx_cnt -radix unsigned
divider add "APP RX"
wave add /TOP_TB/dut/loop_i/rx_state
wave add /TOP_TB/dut/loop_i/rx_data_i -radix hex
wave add /TOP_TB/dut/loop_i/rx_isk_i
wave add /TOP_TB/dut/loop_i/rx_data_bound -radix hex
wave add /TOP_TB/dut/loop_i/rx_isk_bound
wave add /TOP_TB/dut/loop_i/rx_errors_o
wave add /TOP_TB/dut/loop_i/rx_finish_o
wave add /TOP_TB/dut/loop_i/rx_cycles_o -radix unsigned
wave add /TOP_TB/dut/loop_i/rx_cnt -radix unsigned
wave add /TOP_TB/leds

run 100 us
quit
