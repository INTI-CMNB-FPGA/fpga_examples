fpga_device "5CSEBA6U23I7"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "top.vhdl" -top "Top"
fpga_file de10nano.tcl
