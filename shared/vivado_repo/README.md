# Vivado IP repository

## AXIF_MASTER_DPRAM:

* A Dual-Port RAM with an AXI Full Master Interface.
* It uses an AXI Lite interface for control.
* The base files were created with the option *Create a new AXI4 peripheral* of the Vivado IP Packager. Then, we made changes and using files of the *hdl* directory, we create a new Package using the option *Package a specified directory*.
**NOTE**: RUSER and WUSER widths must be 4. AWUSER, ARUSER and BUSER widths must be 1. It is at least in a normal design, to avoid validation complains.
