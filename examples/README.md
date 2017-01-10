# List of examples

* avnet_s6micro:
  * clock:
  * gpios:
  * lpddr:
* lattice_icestick:
  * clock:
  * gpios:
* lattice_breakout:
  * clock:
  * gpios:
* microsemi_m2s090ts:
  * clock:
  * epcs:
  * gpios:
* terasic_de0nano
  * clock:
  * gpios:
* xilinx_sp601:
  * clock:
  * gpios:
* xilinx_ml605: Virtex 6 LXT 240, speed grade -1
  * clock: Using the two on-board clock sources to blink LEDs.
  * ddr3:
  * gpios: Using DIP switches and push-buttons to turn ON LEDs.
  * gtx:   Using a GigaBit Transceiver (gtx with 2 data bytes and 8b10b codification) to change LEDs state with DIP switches.
  * gtx2:  Using a GigaBit Transceiver (gtx with 2 data bytes and 8b10b codification) and TransLoop from fpga_lib.
  * gtx3:  Using a GigaBit Transceiver (gtx with 4 data bytes and 8b10b codification) and TransLoop from fpga_lib.
  * mmcm:  Using Mixed-Mode Clock Manager to blink LEDs.

# Clean (save disk space)

* Examples generates a lot of files:
  * Generated vendor's files to use.
  * Files for simulation.
  * Files for synthesis.
* To delete all of them, run in this directory: `$ make clean`
