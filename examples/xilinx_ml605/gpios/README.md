# Description

This example shows how to use DIP switches, push-buttons and LEDs.
* 8 DIP switches (SW1) drives the adyacent 8 GPIO LEDS.
* 5 direction push-buttons drives the 5 adyacents direction LEDs.

# How to run synthesis, implementation and programming

* For the used FPGA, ISE Design Suite (this example use version 14.7) with a valid license is needed.
* Prepare the environment to use ISE. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Run synthesis, implementation and bitstream generation:
```
$ make bit
```
* Run programing (if fpga_helpers is installed):
```
$ make prog-fpga
```
* Or use impact:
```
$ impact
```

# How to test on hardware

* Change SW1.1..8 to see how the corresponding GPIO LED change its state.
* Hold SW5..9 to see how the corresponding direction LED turn ON.
