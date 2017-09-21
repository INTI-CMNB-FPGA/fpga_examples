fpga_device "10M08SAE144C8G"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "top.vhdl" -top "Top"
fpga_file 10m08.tcl
