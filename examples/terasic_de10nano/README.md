# DE10-Nano development board

## Useful documents

* DE10-Nano User Manual

## Features

* Altera FPGA+SoC 5CSEBA6U23I7NDK (Cyclone V SE)
* Clock sources:
  * Three 50MHz clock sources from the clock generator
* User I/O
  * 8 green user LEDs
  * 2 push-buttons
  * 4 slide switches
  * Two 40-pin expansion Headers
  * One Arduino expansion header (Uno R3 compatibility)
  * One 10-pin ADC input header
* A/D converter, 4-wire SPI interface with FPGA
* HDMI TX, compatible with DVI v1.0 and HDCP v1.4
* Serial Configuration Device EPCS64

HPS
* 800MHz Dual-core ARM Cortex-A9 processor
* 1GB DDR3 SDRAM (32-bit data bus, 2x256Mx16)
* 1 Gigabit Ethernet PHY with RJ45 connector
* USB OTG
* Micro SD card socket
* Accelerometer (I2C interface + interrupt)
* UART to USB, USB Mini-B connector
* Warm reset button and cold reset button
* One user button and one user LED
* LTC 2x7 expansion header

## Power Supply

* 5V DC input

## Programming Options

* Serial configuration device – EPCS64 on FPGA
* USB-Blaster II onboard for programming (Mini-B USB connector)

MSEL[4:0] (SW10, 0 to 4, 5 unused) (0=ON, 1=OFF)
* 01010: boot from SD, compression enabled
* 00000: boot from SD, compression disabled
* 10010: configured from EPCS

To configure the FPGA from JTAG, the SD card must be removed.
