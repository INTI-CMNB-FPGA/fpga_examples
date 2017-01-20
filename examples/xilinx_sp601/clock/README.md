# Description

There are four clock sources on sp601 board:
* On-board differential 200 MHz oscillator.
* On-board single-ended Oscillator Socket populated with 27 MHz.
* User differential through SMA.
* Differential through SMA.
This example is about on-board clock sources. They are used to blink user leds.
The clock of 200 MHz is used to blink LEDs 0 and 1.
The clock of 27 MHz is used to blink LEDs 2 and 3.
CPU_RESET push-button is used to stop and restart blink cycle.

# How to run synthesis, implementation and programming

* For the used FPGA, ISE WebPack is enough (this example uses version 14.7).
* Prepare the environment to use ISE. For example, run:
```
$ . /PATH_TO_ISE/settings64.sh
```
* Run synthesis, implementation and bitstream generation:
```
$ make run
```
* Run programing (or use impact):
```
$ make prog
```

# How to test on hardware

* You must see the 4 user LEDs blinking (1 second ON, 1 second OFF).

# Comments

* Note how to use a differential clock. Some Xilinx examples use IBUFDS + BUFG when IBUFGDS is enough.
* Note that library UNISIM and package VCOMPONENTS was needed to use the primitives.
