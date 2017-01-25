wcfg new

divider add "Clocking"
wave add /top_tb/mig_inst/sys_clk_p
wave add /top_tb/mig_inst/sys_clk_n
wave add /top_tb/mig_inst/clk_ref_p
wave add /top_tb/mig_inst/clk_ref_n
wave add /top_tb/mig_inst/sys_rst
wave add /top_tb/mig_inst/clk
wave add /top_tb/mig_inst/rst
wave add /top_tb/mig_inst/phy_init_done
divider add "Command"
wave add /top_tb/mig_inst/app_addr -radix unsigned
wave add /top_tb/mig_inst/app_cmd
wave add /top_tb/mig_inst/app_en
wave add /top_tb/mig_inst/app_rdy
divider add "Write"
wave add /top_tb/mig_inst/app_wdf_wren
wave add /top_tb/mig_inst/app_wdf_data -radix hex
wave add /top_tb/mig_inst/app_wdf_end
wave add /top_tb/mig_inst/app_wdf_rdy
divider add "Read"
wave add /top_tb/mig_inst/app_rd_data_valid
wave add /top_tb/mig_inst/app_rd_data -radix hex
wave add /top_tb/mig_inst/app_rd_data_end
divider add "State"
wave add /top_tb/state

run 20 us
quit
