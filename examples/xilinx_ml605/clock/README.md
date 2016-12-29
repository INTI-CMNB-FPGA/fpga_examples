# Description

There are four clock sources on ml605 board:
* On-board differential 200 MHz oscillator.
* On-board single-ended Oscillator Socket populated with 66 MHz.
* User differential through SMA.
* MGT differential through SMA.
This example is about on-board clock sources. They are used to blink user leds.
The clock of 200 MHz is used to blink the 8 GPIO LEDs.
The clock of 66 MHz is used to blink the 5 direction LEDs.
CPU Reset push-button (SW10) is used to stop and restart blink cycle.

# How to run synthesis, implementation and programming

* For the used FPGA, ISE Design Suite (this example use version 14.7) with a valid license is needed.
* Prepare the environment to use ISE. For example, run:
 $ . /<PATH_TO_ISE>/ISE_DS/settings64.sh
* Run synthesis, implementation and bitstream generation:
 $ make bit
* Run programing (if fpga_helpers is installed):
 $ make prog-fpga
* Or use impact:
 $ impact

# How to test on hardware

* You must see the 12 user LEDs blinking (1 second ON, 1 second OFF).
* GPIO LEDS with the pattern: "01010101" -> "10101010".
* Direction LEDS with the patter: '0' at center, '1' when others -> '1' at cneter, '0' when others.

# Comments

Note how to use a differential clock. Some Xilinx examples use IBUFDS + BUFG when IBUFGDS is enough.
