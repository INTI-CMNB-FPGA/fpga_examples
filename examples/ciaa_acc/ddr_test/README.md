# Description

DDR write/read simple project to verify correct DDR Hardware operation.

Writes all DDR memory with 0xAAAA5555 then reads all DDR space and compares
with same value in order to verify the correct behaviour.

# How to run synthesis, implementation and programming

* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Open Vivado and create a new proyect for: CIAA ACC
* In Tcl Console, run (block designs generated with Vivado 2018.2):
  * `source <PATH>/ddr_test.tcl`
* Rigth click in Sources -> Design Sources -> design_1 and Create HDL Wrapper.
* Generate Bitstream.
* File -> Export -> Export Hardware (include bitstream)
* Launch SDK
* Generate a new Application Project:
  * OS Platform: standalone
  * Template: Hello World
* Replace `helloworld.c` content with code from:
  * Simple Mode by Interrupts: `<ROOT>/shared/zynq7000/ddrtest.c`
* Transfer the bitstream to the FPGA.
* Configure SDK terminal (or another terminal program) with the needed Port to see UART Output (print) on Debug USB physical port.
* Rigth Click over created project on SDK project explorer -> Run As -> Launch on hardware.

# How to test on hardware

See results in the serial terminal.
