fpga_device "xc6vlx240t-1-ff1156"

fpga_file "temp/mmcm200to150.vhd"
fpga_file "temp/mmcm150and75.vhd"
fpga_file "temp/gbt3_gtx.vhd"
fpga_file "wrapper.vhdl"
fpga_file "../../../fpga_lib/vhdl/verif/verif_pkg.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/loopcheck.vhdl" -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/sync/sync_pkg.vhdl"   -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/sync/boundary.vhdl"   -lib "fpgalib"
fpga_file "../../../fpga_lib/vhdl/verif/transloop.vhdl" -lib "fpgalib"
fpga_file "top.vhdl" -top "Top"
fpga_file "ml605.ucf"
