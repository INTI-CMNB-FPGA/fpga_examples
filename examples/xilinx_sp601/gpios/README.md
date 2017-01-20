# Description

This example shows how to use DIP switches, push-buttons and LEDs.
* 4 DIP switches and 4 push-buttons drives the 4 user LEDS.
* CPU_RESET push-button select between DIP-switches (when holded) or push-buttons.

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

* Change push-buttons to see how the user LEDs change its state.
* Change DIP-switches and hold CPU_RESET to see how the user LEDs change its state.
