# Description

This example shows how to use DIP switches, push-buttons and LEDs.
* 4 DIP switches  drives the 4 LEDS.
* 1 push-button turn ON all the LEDs when holded.

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

* Change DIP switches to see how the user LEDs change its state.
* Hold SW2 to turn ON al the user LEDs.
