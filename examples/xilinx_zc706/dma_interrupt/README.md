# Description

Example about how to use AXI DMA in Direct Register Mode by interrupts.
It writes to AXI DMA the max. quantity of samples of 32 bits (2M-1), reads data back from AXI DMA and compares.

# Useful documents

* AXI DMA v7.1 Product Guide (PG021)

# How to run synthesis, implementation and programming

* For the used FPGA, Vivado System Edition with a valid license is needed.
* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Open Vivado and create a new proyect for: ZYNQ-7 ZC706 Evaluation Board.
* In Tcl Console, run `source <PATH>/dma_interrupt.tcl` (block design generated with Vivado 2017.4).
* Rigth click in Sources -> Design Sources -> design_1 and Create HDL Wrapper.
* Generate Bitstream.
* File -> Export -> Export Hardware (include bitstream)
* Launch SDK
* Generate a new Application Project:
  * OS Platform: standalone
  * Template: Hello World
* Replace `helloworld.c` content with code from `<ROOT>/shared/zynq7000/dma_interrupt.c`.
* Transfer the bitstream to the FPGA.
* Configure SDK terminal (or another terminal program) with the needed Port to see UART Output (J21 - USB UART).
* Rigth Click over polled project -> Run As -> Launch on hardware.

# How to test on hardware

In the serial terminal you must see:
```
* DMA Interrupt Example
* Initializing DMA
* Initializing Interrupts
* Playing with DMA
Try 1
INFO: TX interrupt!
INFO: RX interrupt!
Try 1 passed
Try 2
INFO: TX interrupt!
INFO: RX interrupt!
Try 2 passed
Try 3
INFO: TX interrupt!
INFO: RX interrupt!
Try 3 passed
Try 4
INFO: TX interrupt!
INFO: RX interrupt!
Try 4 passed
Try 5
INFO: TX interrupt!
INFO: RX interrupt!
Try 5 passed
Try 6
INFO: TX interrupt!
INFO: RX interrupt!
Try 6 passed
Try 7
INFO: TX interrupt!
INFO: RX interrupt!
Try 7 passed
Try 8
INFO: TX interrupt!
INFO: RX interrupt!
Try 8 passed
Try 9
INFO: TX interrupt!
INFO: RX interrupt!
Try 9 passed
Try 10
INFO: TX interrupt!
INFO: RX interrupt!
Try 10 passed
* Example Passed
```
