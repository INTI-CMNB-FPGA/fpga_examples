fpga_device "xc6slx16-2-csg324"

fpga_file "top.vhdl" -top "Top"
fpga_file "sp601.ucf"

set fpga_pos  1
set spi_pos   1
set spi_width 1
set spi_name  W25Q64BV
set bpi_pos   1
set bpi_width 8
set bpi_name  28F128J3D
