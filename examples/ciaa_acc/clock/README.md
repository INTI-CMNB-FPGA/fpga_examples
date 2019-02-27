# Description

This example is about on-board clock source. It is used to blink user leds.
The clock of 200 MHz is used to blink LEDs 0 and 2.
The LED 1 is on and LED 3 is off.

# How to run synthesis, implementation and programming

* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Run synthesis, implementation and bitstream generation:
```
$ make run
```
* Run programing:
```
$ make prog
```

# How to test on hardware

* You must see the user LEDs 0 and 2 blinking (1 second ON, 1 second OFF), the LED 1 in state ON and LED 3 in OFF.

# Comments

* Note how to use a differential clock. Some Xilinx examples use IBUFDS + BUFG when IBUFGDS is enough.
* Note that library UNISIM and package VCOMPONENTS are needed to use the primitives.
