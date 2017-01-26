# Description

There is a single clock source on iCEstick EK:
* On-board 12 MHz oscillator.
This example is about on-board clock source used to blink user leds.

# How to run synthesis, implementation and programming

* For the used FPGA, Yosys, arachne-pnr and icestorm tools are needed.
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

* You must see the user LED blinking (1 second ON, 1 second OFF).
