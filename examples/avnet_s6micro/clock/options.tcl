fpga_device "XC6SLX9-2-CSG324"

fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/blink.vhdl"     -lib "fpgalib"
fpga_file "top.vhdl" -top "Top"
fpga_file "s6micro.ucf"

set fpga_pos  1
set spi_pos   1
set spi_width 4
set spi_name  "N25Q128"
