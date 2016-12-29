# FPGA examples

This project is about FPGA hard blocks and board features. Examples ready to use and verified in hardware. The prefered HDL language is VHDL.

## Project Organization

Root directory:
* README.md: this file.
* LICENSE: of the project.
* CONTRIBUTORS.md: list of people who contributed to the project.
* docs/: documentation of the project.
* hdl_utils/: git submodule.
* synthesis/: shared TCL files to do synthesis. Generated by fpga_helpers.
* examples/: where the examples lives!

example directory:
* README.md: list of available examples.
* Several *vendor_board* sub directories.

*vendor_board* directories:
* README.md: general information about features, Power Supply and Programming Options.
* Directories with examples for the given board.

Examples directories:
* README.md: tutorial about how to run and reproduce the example.
* top.vhdl: top level.
* resources [optional]: additional files provided by the vendor.
* wrapper.vhdl [optional]: a wrapper for resources when complex, to have a cleanest top level.
* Makefile: generated by fpga_helpers to run synthesis and implementation.
* options.tcl: generated by fpga_helpers and customized by the user.
* Constraint file such as <board.ext>.
* testbench [optional]: only provided when useful (no trivial such as gpios) or posible (no license problems).

testbench directories:
* top_tb.vhdl: test or at least stimulus to see waveforms.
* Makefile: to run the test and see waveforms.
* files.<ext>: the files of the project.
* waves.<ext>: waveform to visualize.
