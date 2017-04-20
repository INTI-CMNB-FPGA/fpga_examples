# Description

This example shows how to use DIP switches, push-buttons and LEDs.
* 4 DIP switches and 4 push-buttons drives 4 LEDS.
* This example do not use the PS part (Zynq), only PL.

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

* Change SW0..3 to see how GPIO LEDs change its state.
* Hold BTN0..3 to see how GPIO LEDs change its state.
