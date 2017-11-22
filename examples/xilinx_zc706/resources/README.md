# How resources were obtained

## Project Creation

* Run vivado.
* Generate a New Project for Zynq-7 ZC706 board (xc7z045ffg900-2, ffg900, -2).
* Finish.

# GTX (8b/10b, 2 bytes)

* IP catalog
* Navigate: FPGA Features and Design -> IO Interfaces.
* Run "7 Series FPGAs Transceivers Wizard".

7 Series FPGAs Transceivers Wizard:
* Component Name=gbt1
* GT Selection:
  * Include Shared Logic in example design
* Line Rate, RefClk Selection:
  * TX=RX:
    * Line Rate (Gbps): 10
    * Reference Clock (MHz): 200
  * Uncheck 'Use GTX X0Y0'
  * Check 'Use GTX X0Y11' (wired in a capacitively coupled TX-to-RX loopback configuration)
    * TX Clock Source: REFCLK1 Q2
    * RX Clock Source: automatically the same as TX clock Source
* Encoding and clocking:
  * TX=RX:
    * External Data Width (Bits): 40
    * Encoding/Decoding: None
    * Internal Data Width (Bits): 40
  * DRP/System Clock Frequency (MHz): 160
* Comma alignment and Equalization
  * Uncheck Use comma detection
* PCIe, SATA, PRBS:
  * Check LOOPBACK
* OK

# GTX2 (8b/10b, 4 bytes)

* IP catalog
* Navigate: FPGA Features and Design -> IO Interfaces.
* Run "7 Series FPGAs Transceivers Wizard".

7 Series FPGAs Transceivers Wizard:
* Component Name=gbt2
* GT Selection:
  * Include Shared Logic in example design
* Line Rate, RefClk Selection:
  * TX=RX:
    * Line Rate (Gbps): 10
    * Reference Clock (MHz): 200
  * Uncheck 'Use GTX X0Y0'
  * Check 'Use GTX X0Y11' (wired in a capacitively coupled TX-to-RX loopback configuration)
    * TX Clock Source: REFCLK1 Q2
    * RX Clock Source: automatically the same as TX clock Source
* Encoding and clocking:
  * TX=RX:
    * External Data Width (Bits): 32
    * Encoding/Decoding: 8b/10b
    * Internal Data Width (Bits): 40
  * DRP/System Clock Frequency (MHz): 160
* Comma alignment and Equalization
  * Align to... Four byte Boundaries (to ensure K character in byte 0 and value in bytes 1, 2 and 3)
  * Uncheck RXSLIDE
  * Check RXBYTEISALIGN
* PCIe, SATA, PRBS:
  * Check LOOPBACK
* OK
