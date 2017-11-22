fpga_device "xc7z045-2-ffg900"

fpga_file "temp/gbt1/example_design/gbt1_rx_startup_fsm.vhd"
fpga_file "temp/gbt1/example_design/gbt1_sync_block.vhd"
fpga_file "temp/gbt1/example_design/gbt1_tx_startup_fsm.vhd"

fpga_file "temp/gbt1_gt.vhd"
fpga_file "temp/gbt1_multi_gt.vhd"
fpga_file "temp/gbt1_init.vhd"
fpga_file "temp/gbt1.vhd"

fpga_file "wrapper.vhdl"
fpga_file "top.vhdl" -top "Top"

fpga_file "zc706.xdc"
