# Description

There is a single clock source on iCEstick EK:
* On-board 12 MHz oscillator.
This example is about on-board clock source used to blink user leds.

# How to run simulation

* For the simulation the icarus verilog simulator has been used, to run the
simulation you must have iverilog and gtkwave tools installed.
```
* Run simulation:
```
$ make simu
```
* Open the waveforms:
```
$ make view
```

# How to test on hardware

* You must see the user LEDs blinking (1 second green LEDs ON, 1 second red LED ON), 
when green LEDs are on, red LED is off and vice versa.
