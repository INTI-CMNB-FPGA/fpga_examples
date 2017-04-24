fpga_device "XC3S1500-4-FG676"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "top.vhdl" -top "Top"
fpga_file "s3dev1500.ucf"

set fpga_pos  2

