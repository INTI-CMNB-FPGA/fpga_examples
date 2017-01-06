wcfg new

wave add /TOP_TB/dut/clk_p_i
wave add /TOP_TB/dut/rst_i
wave add /TOP_TB/dut/sysclk
wave add /TOP_TB/dut/rst_gtx
divider add "Wrapper"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/LOOPBACK_IN
divider add "RX 8b10b Decoder"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXCHARISK_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXDISPERR_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXNOTINTABLE_OUT
divider add "RX Comma Detection and Alignment"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXBYTEISALIGNED_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXENMCOMMAALIGN_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXENPCOMMAALIGN_IN
divider add "RX Data Path interface"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXDATA_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXUSRCLK_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXUSRCLK2_IN
divider add "RX Driver"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXN_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXP_IN
divider add "RX PLL Ports"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/GTXRXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/MGTREFCLKRX_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/PLLRXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXPLLLKDET_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/RXRESETDONE_OUT
divider add "TX 8b10b Encoder Control Ports"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXCHARISK_IN
divider add "TX Data Path interface"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXDATA_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXOUTCLK_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXUSRCLK_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXUSRCLK2_IN
divider add "TX Driver"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXN_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXP_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXPOSTEMPHASIS_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXPREEMPHASIS_IN
divider add "TX PLL Ports"
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/GTXTXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/MGTREFCLKTX_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/PLLTXRESET_IN
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXPLLLKDET_OUT
wave add /TOP_TB/dut/gbt_i/gtx_v6_i/TXRESETDONE_OUT
divider add "Boundary"
wave add /TOP_TB/dut/rx_isk
wave add /TOP_TB/dut/rx_data -radix hex
wave add /TOP_TB/dut/rx_isk_bound
wave add /TOP_TB/dut/rx_data_bound -radix hex
divider add "TransLoop"
wave add /TOP_TB/dut/clk
wave add /TOP_TB/dut/rst_loop
wave add /TOP_TB/dut/tx_data -radix hex
wave add /TOP_TB/dut/tx_isk
wave add /TOP_TB/dut/ready
wave add /TOP_TB/dut/rx_data_bound -radix hex
wave add /TOP_TB/dut/rx_isk_bound
wave add /TOP_TB/dut/errors
wave add /TOP_TB/dut/finish
wave add /TOP_TB/dut/loop_i/tx_state
wave add /TOP_TB/dut/loop_i/rx_state
wave add /TOP_TB/dut/loop_i/tx_cnt
wave add /TOP_TB/dut/loop_i/rx_cnt
divider add "LoopCheck"
wave add /TOP_TB/dut/loop_i/tx_clk_i
wave add /TOP_TB/dut/loop_i/tx_rst_i
wave add /TOP_TB/dut/loop_i/tx_stb
wave add /TOP_TB/dut/loop_i/tx_data_i
wave add /TOP_TB/dut/loop_i/tx_data
wave add /TOP_TB/dut/loop_i/rx_clk_i
wave add /TOP_TB/dut/loop_i/rx_rst_i
wave add /TOP_TB/dut/loop_i/rx_stb
wave add /TOP_TB/dut/loop_i/rx_data
wave add /TOP_TB/dut/loop_i/rx_errors_o
wave add /TOP_TB/dut/loop_i/loop_i/tx_qty
wave add /TOP_TB/dut/loop_i/loop_i/rx_qty

run 100 us
quit
