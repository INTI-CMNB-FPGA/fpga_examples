# Description

There are three clock sources on DE10-Nano board:
* 3 x On-board 50 MHz oscillator.
This example is about on-board clock sources. They are used to blink 3 leds.
Push Button KEY0 is used as Reset to stop and restart blink cycle.

# How to run synthesis, implementation and programming

* A free Quartus license is enough for the used FPGA (this example uses Quartus Primer Lite 18.1).
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

* You must see 3 LEDs (2:0) blinking.
