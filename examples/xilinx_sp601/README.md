# Spartan-6 FPGA SP601 Evaluation Kit

## Useful documents

* SP601 Hardware User Guide (ug518)
* Getting Started with the Xilinx Spartan-6 FPGA SP601 Evaluation Kit (ug523)
* SP601 Reference Design User Guide (ug524)

## Features

* Xilinx FPGA XC6SLX16-2CSG324 (Spartan-6, grade 2)
* Clock sources:
  * 2.5V LVDS differential 200 MHz oscillator (SiTime SiT9102AI-243N25E200.00000) with 50 ppm
  * One populated (27 MHz, 2.5V) single-ended clock socket
  * SMA Connectors (Differential)
    * Onboard 50 Ohm SMA connectors
* User I/O
  * User LEDs (4)
  * DIP switches (4)
  * Push-buttons (5, 4 assigned to GPIOs and 1 assigned to CPU_RESET)
  * 2X6 GPIO male pin header supporting 3.3V power, GND and eight I/Os which support LVCMOS25
* 128 MB DDR2 Component Memory (1-Gb Elpida EDE1116ACBG)
* SPI X4 (Winbond W25Q64VSFIG) 64-Mb flash memory device for programming
* An 8-bit (16 MB) Numonyx linear flash memory (TE28F128J3D-75) to provide non-volatile bitstream, code, and data storage.
* 10/100/1000 Tri-Speed Ethernet PHY (Marvell Alaska 88E1111) with GMII/MII interfaces
* Silicon Labs CP2103GM USB-to-UART bridge
* VITA 57.1 FMC-LPC Connector
* IIC bus which includes the FPGA and 3 items:
  * 2-pin external access header
  * 8Kb NV Memory (ST MICRO M24 C08-WDW6TP)
  * VITA 57.1 FMC Connector

## Power Supply

* 5V (+ in centre).

## Programming Options

* JTAG configuration is provided through onboard USB-to-JTAG configuration logic (Mini-B J10).
* FPGA is always en jtag chain.
* J4 must be in 1-2 to bypass FMC.

* SPI x4 (J15 must be close to use the on-board spi)
* BPI
* JTAG

Mode Pins M1, M0 (M2 is connected to 0):
* 00: BPI
* 01: SPI
* Any: JTAG
