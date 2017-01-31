# Description

There is a single clock source on iCE40-HX8K Breakout Board:
* On-board 12 MHz oscillator.
This example is about on-board clock source used to blink user leds.

# How to run synthesis, implementation and programming

* For the iCE40 FPGA, Yosys, arachne-pnr and icestorm tools have been used.
You can choose the iCEcube tools instead, but you will have to create a new 
FPGA project if so.
```
* Run synthesis, implementation and bitstream generation:
```
$ make run
```
* Run programming:
```
$ make prog
```

# How to test on hardware

* You must see the user LEDs blinking following the next pattern:
   X00XX00X --> 0XX00XX0 .
