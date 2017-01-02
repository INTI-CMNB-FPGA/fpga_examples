# Description

This example shows how to synthetize clocks using the *Mixed-Mode Clock Manager*.

# Useful documents

* Virtex-6 FPGA Clocking Resources User Guide (UG362)

# How resources were obtained

Run Coregen (example with ISE 14.7) and:
* Generate a New Project for Virtex6, xc6vlx240t, ff1156, -1. Design entry: VHDL.
* Navigate: FPGA Features and Design -> Clocking.
* Run "Clocking Wizard".

Clocking Wizard:
* Page 1:
  * Change component name to mmcm.
  * Change input freq value to *200.00* and source to *Differential clock capable pin*.
* Page 2:
  * CLK_OUT1 = 50, CLK_OUT2 = 100, CLK_OUT3 = 150, CLK_OUT4 = 200, CLK_OUT5 = 250, CLK_OUT6 = 300.
* Page 3: no changes (provides RESET and LOCKED ports)
* Page 4/5: no changes
* Page 6: no changes to use the default ports names.
* Page 7: nothing to do (summary).
* Generate

# How to use resources

* The file mmcm.vhd is a wrapper for *MMCM_ADV* primitive, plus one *IBUFGDS* primitive and several *BUFG* primitives (CLK_OUTx ports).
* The component mmcm is instantiated in top.vhdl.

# How to simulate

The testbench are only stimulus to see waveforms.

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE Isim. For example, run:
    $ . /PATH_TO_ISE/ISE_DS/settings64.sh
* Enter to testbench directory
    $ cd testbench
* Compiling
    $ make
* See waveforms:
    $ make see

# How to run synthesis, implementation and programming

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE. For example, run:
    $ . /PATH_TO_ISE/ISE_DS/settings64.sh
* Prepare resources (skip this step if already generated):
    $ ./prepare.sh
* Run synthesis, implementation and bitstream generation:
    $ make bit
* Use impact to transfer or, if fpga_helpers is installed, run:
    $ make prog-fpga

# How to test on hardware

* The six resulting clocks are used to blink the first six GPIO LEDS (1 second ON, 1 second OFF).
* GPIO LED 0 ->  50MHz
* GPIO LED 1 -> 100MHz
* GPIO LED 2 -> 150MHz
* GPIO LED 3 -> 200MHz
* GPIO LED 4 -> 250MHz
* GPIO LED 5 -> 300MHz

# Comments

* If you see waveforms, clock of 250 MHz is not in phase.
* If you test in hardware, GPIO LED 4, which represent clock 250 MHz, blink wrong.
* Why? Let me explain seeing some interesting parameters inside mmcm.vhd, when MMCM_ADV is instantiated:
```
...
DIVCLK_DIVIDE        => 1,
CLKFBOUT_MULT_F      => 6.000,
CLKOUT0_DIVIDE_F     => 24.000,
CLKOUT1_DIVIDE       => 12,
CLKOUT2_DIVIDE       => 8,
CLKOUT3_DIVIDE       => 6,
CLKOUT4_DIVIDE       => 5,
CLKOUT5_DIVIDE       => 4,
CLKIN1_PERIOD        => 5.0,
...
```
  * The input clock (200 MHz) has a period of 5 ns. This is indicated with CLKIN1_PERIOD.
  * The input clock is multiplied by CLKFBOUT_MULT_F (6.0) and divided by DIVCLK_DIVIDE (1): 200 * 6 = 1200
  * The output clocks are obtained by dividing:
    * CLKOUT0 -> 1200/24 = 50 MHz
    * CLKOUT1 -> 1200/12 = 100 MHz
    * CLKOUT2 -> 1200/8  = 150 MHz
    * CLKOUT3 -> 1200/6  = 200 MHz
    * CLKOUT4 -> 1200/5  = 240 MHz -> WRONG!!!
    * CLKOUT5 -> 1200/4  = 300 MHz
  * The needed divisor value is 4.8 but is not supported.
  * Note that the only divisor expressed by a real number is CLKOUT0_DIVIDE_F.
* How to solve this problem?
  * Using another MMCM to generate 250 MHz.
  * Play with values (inside the valid range) trying to obtain another combination which works.
    * Be careful, I saw simulation missmatches when using real values with decimal part different of 0 with MMCM_ADV.
