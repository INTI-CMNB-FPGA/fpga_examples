# Description

Example about how to use AXI DMA in Simple and Scatter Gather Mode.

In Simple Mode, it writes to AXI DMA the max. quantity of samples of 32 bits (2M-1), reads data back from AXI DMA and compares.

# Useful documents

* AXI DMA v7.1 Product Guide (PG021)

# How to run synthesis, implementation and programming

* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Open Vivado and create a new proyect for: Zybo.
* In Tcl Console, run (block designs generated with Vivado 2017.4):
  * For Simple Mode: `source <PATH>/simple.tcl`
  * For Scatter Gather Mode: `source <PATH>/sg.tcl`
* Rigth click in Sources -> Design Sources -> design_1 and Create HDL Wrapper.
* Generate Bitstream.
* File -> Export -> Export Hardware (include bitstream)
* Launch SDK
* Generate a new Application Project:
  * OS Platform: standalone
  * Template: Hello World
* Replace `helloworld.c` content with code from:
  * Simple Mode by Polling: `<ROOT>/shared/zynq7000/dma_simple_polling.c`
  * Simple Mode by Interrupts: `<ROOT>/shared/zynq7000/dma_simple_interrupt.c`
* Transfer the bitstream to the FPGA.
* Configure SDK terminal (or another terminal program) with the needed Port to see UART Output (J11 - PROG UART).
* Rigth Click over polled project -> Run As -> Launch on hardware.

# How to test on hardware

See results in the serial terminal.
