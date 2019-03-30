# Description

Examples about how to use the Zynq AXI interfaces to write/read a BRAM in the PL.

In the axi_master project, there are three individual examples about how to use M_AXI_GP:
* Using Xil_Out32 and Xil_In32 functions.
* Using the memcpy function.
* Using the PS DMA.

In the axi_slaves project, there are three individual examples about how to use S_AXI_GP, S_AXI_ACP and S_AXI_HP:

# How to run synthesis, implementation and programming

* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Open Vivado and create a new proyect for: Zybo.
* Go to Settings -> IP -> Repository
  * Add `<FPGA_EXAMPLES>/shared/vivado_repo`
* In Tcl Console, run (block designs generated with Vivado 2018.2):
  * For M_AXI_GP: `source <PATH>/axi_master.tcl`
  * For S_AXI_GP, S_AXI_ACP, S_AXI_HP: `source <PATH>/axi_slaves.tcl`
* Rigth click in Sources -> Design Sources -> design_1 and Create HDL Wrapper.
* Generate Bitstream.
* File -> Export -> Export Hardware (include bitstream)
* Launch SDK
* Generate a new Application Project:
  * OS Platform: standalone
  * Template: Hello World
* Replace `helloworld.c` content with code from:
  * axi_master: `<ROOT>/shared/zynq7000/axi_master.c`
  * axi_slaves: `<ROOT>/shared/zynq7000/axi_slaves.c`
* Transfer the bitstream to the FPGA.
* Configure SDK terminal (or another terminal program) with the needed Port to see UART Output (J11 - PROG UART).
* Rigth Click over the SDK project -> Run As -> Launch on hardware.

# How to test on hardware

See results in the serial terminal.
