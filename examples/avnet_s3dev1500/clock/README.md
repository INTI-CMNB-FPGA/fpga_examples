# Description

There are four clock sources on s3dev1500 board:
* 3 are user programmable. Default values:
* 1 Optional user installable of 66 MHz (not installed)
They are used to blink user leds.
The clock of 66 MHz  is used to blink LEDs 0.
The clock of HEADER  is used to blink LEDs 1.
The clock of 100 MHz is used to blink LEDs 2.
The clock of 40  MHz is used to blink LEDs 3.
CPU_RESET push-button is used to stop and restart blink cycle.

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

* You must see at least 3 user LEDs blinking (1 second ON, 1 second OFF).
* LED 1 is always OFF if the optional clock HEADER is not installed (factory default).
