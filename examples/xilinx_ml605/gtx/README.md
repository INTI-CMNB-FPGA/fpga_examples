# Description

* Simple example about how to use a GigaBit Transciver (GTX) on ml605.
* It uses 8b10b and 16 data bits.
* The DIP switches drives the GPIO LEDS trougth a gtx configured with a loopback.
* GTX loopback is used, unless push-button GPIO_SW_C is holded.

# Useful documents

* Virtex-6 FPGA GTX Transceivers User Guide (UG366)

# How resources were obtained

Run Coregen (example with ISE 14.7) and:
* Generate a New Project for Virtex6, xc6vlx240t, ff1156, -1. Design entry: VHDL.
* Navigate: FPGA Features and Design -> IO Interfaces.
* Run "Virtex-6 FPGA GTX Transceiver Wizard".

Virtex-6 FPGA GTX Transceiver Wizard:
* Page1:
  * Component Name=v6
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
  * Align to... Even Byte Boundaries
  * Check RXBYTEISALIGNED
* Page4:
  * Main driver differential swing -> "0000"
  * Wideband/Highpass Ratio -> "000"
  * Uncheck Synchronous Application
* Page4, 5, 6 y 7:
  * No changes.
* Generate

An additional MMCM is needed to obtain 150 MHz from 200 MHz. In Coregen:
* Navigate: FPGA Features and Design -> Clocking.
* Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm.
  * Change input freq value to *200.00* and source to *Differential clock capable pin*.
* Page 2:
  * CLK_OUT1 = 150.
* Page 3: no changes (provides RESET and LOCKED ports)
* Page 4: Allow override mode
  * Change CLKFBOUT_MULT_T from 39.000 to 6.000.
  * Change DIVCLK_DIVIDE from 8 to 2.
  * Change CLKOUT0_DIVIDE_F from 6.500 to 4.000.
  * Note: changes to avoid a division with decimal part different to zero (simulation missmatch).
* Page 5: no changes to use the default ports names.
* Page 6: nothing to do (summary).
* Generate

# How to use resources

* See wrapper.vhdl.
* txoutclk is used to drive txusrclk2 and rxusrclk2 trough IBUFG.
* If 4 byte of data are used, two clocks are derived from txoutclk (using a MMCM).
* The useful ports are tx_data, tx_isk, rx_data, rx_isk and ready.
* When a byte of data is a K character, the corresponding isk bit must be 1.

# How to simulate

The testbench are only stimulus to see waveforms.

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

See how when rxbyteisaligned is '1', the values in txdata and txcharisk arrive to rxdata and rxcharisk.

# How to run synthesis, implementation and programming

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Prepare resources (skip this step if already generated):
```
$ ./prepare.sh
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

* Change SW1.1..8 to see how the corresponding GPIO LED change its state.
* If two SMA cables are used to connect TX_P_O with RX_P_I and TX_N_O with RX_N_I, hold GPIO_SW_C to avoid internal loopback.

# Comments

* In ml605.ucf there are examples of clock constraints. It is not absolutely needed in this example, but good practice for a real app.
