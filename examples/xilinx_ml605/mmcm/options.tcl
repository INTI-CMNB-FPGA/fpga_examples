fpga_device "XC6VLX240T-1-FF1156"

fpga_file "../../../hdl_utils/vhdl/verif/verif_pkg.vhdl" -lib "utils"
fpga_file "../../../hdl_utils/vhdl/verif/blink.vhdl"     -lib "utils"
fpga_file "resources/mmcm.vhd"
fpga_file "top.vhdl"                                     -top "Top"
fpga_file "ml605.ucf"
