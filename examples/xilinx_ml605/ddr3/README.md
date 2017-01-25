# Description

# Useful documents

* Virtex-6 FPGA Memory Interface Solutions User Guide (UG406)
  * Chapter 1: DDR2 and DDR3 SDRAM Memory Interface Solution
* ML605 MIG Design Creation (xtp047)

# How to use resources

# How to simulate

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE Isim. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Prepare resources (skip this step if already generated):
```
$ make prepare
```
* Enter to testbench directory
```
$ cd testbench
```
* Compile
```
$ make
```
* See waveforms:
```
$ make see
```

# How to run synthesis, implementation and programming

* This design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240.
* Prepare the environment to use ISE. For example, run:
```
$ . /PATH_TO_ISE/ISE_DS/settings64.sh
```
* Prepare resources (skip this step if already generated):
```
$ make prepare
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

# Comments

