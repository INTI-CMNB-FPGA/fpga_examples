# Description

There is one clock source on DE0-Nano board:
* On-board 50 MHz oscillator.
This example is about on-board clock source. It is used to blink the 8 leds.
Push Button KEY1 is used as Reset to stop and restart blink cycle.

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

* You must see the 8 user LEDs blinking, with the pattern: "01010101" -> "10101010".
