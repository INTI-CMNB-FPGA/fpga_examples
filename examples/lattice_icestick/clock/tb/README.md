# Description

There is a single clock source on iCEstick EK:
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

* You must see the user LEDs blinking (1 second green LEDs ON, 1 second red LED ON), 
when green LEDs are on, red LED is off and vice versa.
