fpga_device "xc7z030fbg676-2"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "top.vhdl"                                     -top "Top"

fpga_file "ciaa_acc.xdc"
