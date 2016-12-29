wcfg new

onerror {resume}
isim set radix hex

divider add "Inputs"
wave add /top_tb/dut/clk_p_i
wave add /top_tb/dut/clk_n_i
wave add /top_tb/dut/rst_i
wave add /top_tb/dut/locked
wave add /top_tb/dut/blink_reset
divider add "Outputs"
wave add /top_tb/dut/clk50
wave add /top_tb/dut/clk100
wave add /top_tb/dut/clk150
wave add /top_tb/dut/clk200
wave add /top_tb/dut/clk250
wave add /top_tb/dut/clk300
wave add /top_tb/dut/leds_o

run 1 us
quit
