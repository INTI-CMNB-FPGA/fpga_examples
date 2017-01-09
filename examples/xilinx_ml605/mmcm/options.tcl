fpga_device "XC6VLX240T-1-FF1156"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "resources/mmcm.vhd"
fpga_file "top.vhdl"                                    -top "Top"
fpga_file "ml605.ucf"
