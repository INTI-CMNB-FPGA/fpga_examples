# Description

Using a GigaBit Transceiver (gtx with 2 data bytes and 8b10b codification) and TransLoop from hdl_utils.
* Transloop TX and RX data, checking that it was received fine.
* It sends data in the form: K28.5 | DATA | K28.1 | DATA | K28.1 | DATA | K28.1 | DATA | K28.5
  * K28.5 is used to signaling start and end.
  * K28.1 is used as data separator.
  * DATA is an incremental counter value.
* The status of Transloop is shown in GPIO LEDS.
* Boundary from hdl_utils is also used. It is used to ensure that we understand *rx_data* in the same order that *tx_data*.

# Useful documents

* Virtex-6 FPGA GTX Transceivers User Guide (UG366)

# How resources were obtained

Similar to gtx example of the same board. Changes:
* Page3:
  * Align to... Any Byte Boundaries

# How to use resources

* Idem. gtx example of the same board. Is the same wrapper.vhdl file.

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

* The difference with gtx example of the same board, is that here the option *Align to... Any Byte Boundaries* is used.
* It is needed because we use control words with more than a one K characters (using even and odd bytes).
