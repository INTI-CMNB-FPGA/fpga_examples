# Coregen Project for ml605 board

* To open:
```
coregen -p .
```

# How resources were obtained

## Project Creation

* Run Coregen.
* Generate a New Project for Virtex6, xc6vlx240t, ff1156, -1.
* Design entry: VHDL.

## MMCM

* Run Coregen.
* Navigate: FPGA Features and Design -> Clocking.
* Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm.
  * Change input freq value to *200.00* and source to *Differential clock capable pin*.
* Page 2:
  * CLK_OUT1 = 50
  * CLK_OUT2 = 100
  * CLK_OUT3 = 150
  * CLK_OUT4 = 200
  * CLK_OUT5 = 250
  * CLK_OUT6 = 300.
* Page 3: no changes (provides RESET and LOCKED ports)
* Page 4/5: no changes
* Page 6: no changes to use the default ports names.
* Page 7: nothing to do (summary).
* Generate

# MMCM from 200 to 150 MHz

* Run Coregen.
* Navigate: FPGA Features and Design -> Clocking.
* Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm200to150.
  * Change input freq value to *200.00* and source to *Differential clock capable pin*.
* Page 2:
  * CLK_OUT1 = 150.
* Page 3: no changes (provides RESET and LOCKED ports)
* Page 4: Allow override mode
  * Change CLKFBOUT_MULT_F from 39.000 to 6.000.
  * Change DIVCLK_DIVIDE from 8 to 2.
  * Change CLKOUT0_DIVIDE_F from 6.500 to 4.000.
  * Note: changes to avoid a division with decimal part different to zero (simulation missmatch).
* Page 5: no changes to use the default ports names.
* Page 6: nothing to do (summary).
* Generate

# MMCM to obtain 150 and 75 MHz

* Run Coregen.
* Navigate: FPGA Features and Design -> Clocking.
* Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm150and75.
  * Change input freq value to *150.00* and source to *No buffer* (very important! it is not an external clock source).
* Page 2:
  * CLK_OUT1 = 150.
  * CLK_OUT2 = 75.
* Page 3: no changes (provides RESET and LOCKED ports)
* Page 4: Allow override mode
  * Change CLKFBOUT_MULT_F from 13.000 to 16.000.
  * CLKIN1_PERIOD to 6.67.
  * DIVCLK_DIVIDE = 2.
  * Change CLKOUT0_DIVIDE_F from 6.500 to 8.000.
  * Change CLKOUT1_DIVIDE from 13 to 16.
  * Note: changes to avoid a division with decimal part different to zero (simulation missmatch).
* Page 5: no changes to use the default ports names.
* Page 6: nothing to do (summary).
* Generate

# GTX1 (8b/10b, 2 bytes and Even boundary)

* Run Coregen.
* Navigate: FPGA Features and Design -> IO Interfaces.
* Run "Virtex-6 FPGA GTX Transceiver Wizard".

Virtex-6 FPGA GTX Transceiver Wizard:
* Page1:
  * Component Name=gbt1
  * Template=Start from scratch
  * TX=RX:
    * Line Rate: 3 Gbps
    * Data Path Width: 16
    * Encoding 8b/10b
    * Reference Clock: 150 MHz (200 MHz is not a an option)
* Page2:
  * Uncheck 'Use GTX X0Y0'
  * Check 'Use GTX X0Y18'
    * TX Clock Source: use rx pll
    * RX Clock Source: GREFCLK (in a real app, a REFCLKx must be used)
* Page3:
  * Uncheck RXCOMMADET
  * Align to... Even Byte Boundaries (to ensure K character in byte 0 and value in byte 1)
  * Check RXBYTEISALIGNED
* Page4:
  * Main driver differential swing -> "0000"
  * Wideband/Highpass Ratio -> "000"
  * Uncheck Synchronous Application
* Page4, 5, 6 y 7:
  * No changes.
* Generate

# GTX2 (8b/10b, 2 bytes and Any boundary)

Similar to gtx1. Changes:
* Page3:
  * Align to... Any Byte Boundaries

# GTX3 (8b/10b, 4 bytes and Any boundary)

Similar to gtx2. Changes:
* Page1:
  * Data Path Width (TX & RX): 32 bits.

# DDR3

* Run Coregen.
* Navigate: Memories & Storage elements -> Memory interface Generators.
* Run "MIG Virtex-6 and Spartan-6".

Memory Interface Generator:
* CORE Generator Options: Nothing to do, Next.
* Create Design, component name *mig*, Next.
* Pin Compatible FPGAs: do not touch, Next.
* Memory Selection: DDR3 SDRAM, Next.
* Options for Controller 0:
  * Memory type = SODIMMs
  * Memory Part: MT4JSF6464HY-1G1
  * Ordering: strict <sup>1</sup>
  * Next.
* Memory Options for Controller 0: do not touch, Next.
* FPGA Options: do not touch, Next.
* Extended FPGA Options: New Design, Next.
* Bank Selection For Controller 0:
  * Deselect Banks
  * Bank 32: Address/Control
  * Bank 25, 26, 27: Data
  * Bank 34: System clock
  * Master bank: 25
  * Next.
* Summary: nothing to do, Next.
* Memory Model: Accept, Next.
* PCB Information: nothing to do, Next.
* Desgin Notes: nothing to do, Generate.

<sup>1</sup>
When set to NORMAL, ORDERING enables the reordering algorithm in the MC. When set to STRICT,
request reordering is disabled, which greatly limits throughput to the external memory device.
However, it can be helpful during initial core integration because requests are processed in the
order received; the user design does not need to keep track of which requests are pending and which
requests have been processed.
