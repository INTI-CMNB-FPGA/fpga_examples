# Description

This example shows how to use DIP switches, push-buttons and LEDs.
* 4 DIP switches and 2 push-buttons drives the 8 LEDs.

# How to run synthesis, implementation and programming

* A free Quartus license is enough for the used FPGA (this example uses Quartus2 15.0).
* Prepare the environment to use Quartus.
* Run synthesis, implementation and bitstream generation:
```
$ make run
```
* Run programing (or use Quartus):
```
$ make prog
```

# How to test on hardware

* Change DIP switches and pushbuttons (KEY0 and KEY1) to see how the LEDs changes its state.
* KEY0 drives LED4 and LED6 (not LED4).
* KEY0 drives LED5 and LED7 (not LED5).
* DIP switches drives LED0..3.
