# Description

Using a GigaBit Transceiver (gtx with 4 data bytes and 8b10b codification) and TransLoop from fpga_lib.
* Similar to gtx2 example of the same board, but using 4 bytes of data.
* Transloop TX and RX data, checking that it was received fine.
* It sends data in the form: K28.5 | DATA | K28.1 | DATA | K28.1 | DATA | K28.1 | DATA | K28.5
  * K28.5 is used to signaling start and end.
  * K28.1 is used as data separator.
  * DATA is an incremental counter value.
* The status of Transloop is shown in GPIO LEDS.
* Boundary from fpga_lib is also used, to ensure that we understand *rx_data* in the same order that *tx_data*.

# Useful documents

* Virtex-6 FPGA GTX Transceivers User Guide (UG366)

# How resources were obtained

Similar to gtx2 example of the same board. Changes:
* Page1:
  * Data Path Width (TX & RX): 32 bits.
* Another MMCM is needed to obtain usrclk and usrclk2 from txoutclk. In Coregen:
  * Navigate: FPGA Features and Design -> Clocking.
  * Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm_gtx.
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

# How to use resources

* The file wrapper.vhdl is different to gtx and gtx2 example.
* Here usrclk and usrclk2 must be obtained from txoutclk.
* Signal *locked* from MMCM was added to *ready* generation.

# How to simulate

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE Isim. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Enter to testbench directory
```
$ cd testbench
```
* Compile
```
$ make
```
* See waveforms:
```
$ make see
```

# How to run synthesis, implementation and programming

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Prepare resources (skip this step if already generated):
```
$ make prepare
```
* Run synthesis, implementation and bitstream generation:
```
$ make bit
```
* Use impact to transfer or, if fpga_helpers is installed, run:
```
$ make prog-fpga
```

# How to test on hardware

* GPIO LEDS 0 to 4 indicates errors (must be in 0 at the end of the test):
  * 0: no data exchanged.
  * 1: value missmatch.
  * 2: quantity missmatch.
  * 3: less quantity.
  * 4: more quantity.
* GPIO LEDS 5 and 6 were not used (always OFF).
* GPIO LED 7 ON indicate that the test finished.
* If two SMA cables are used to connect TX_P_O with RX_P_I and TX_N_O with RX_N_I, hold GPIO_SW_C to avoid internal loopback, press and release USER RESET to rerun.

# Comments

* Width of signals tx_data, rx_data, tx_isk and rx_isk were modified because the change from 2 to 4 bytes.
* The additional mmcm_gtx was needed because that the generated in the example do not works for the used FPGA.
  * Run testbench on resources/v6/simulation/functional to see warning message about it.
