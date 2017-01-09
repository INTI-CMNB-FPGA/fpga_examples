wcfg new

wave add /TOP_TB/dut/clk_p_i
wave add /TOP_TB/dut/sysclk
wave add /TOP_TB/dut/reset
divider add "TX Clocking"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/MGTREFCLKTX_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXOUTCLK_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXUSRCLK2_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/GTXTXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXPLLLKDET_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXRESETDONE_OUT
divider add "RX Clocking"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/MGTREFCLKRX_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXUSRCLK2_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/GTXRXRESET_IN
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
divider add "Differential"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXN_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXP_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXN_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXP_IN
divider add "Loop"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/LOOPBACK_IN

run 1 us
quit
