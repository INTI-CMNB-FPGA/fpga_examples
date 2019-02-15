# CIAA ACC

## Useful documents

* [CIAA ACC Hardware User guide](https://github.com/ciaa/CIAA_ACC_Support/tree/master/doc)

## Features

* ZYNQ XC7Z030-2FBG676I (Zynq 7000, grade 2)
* Connected to PS part
  * 2 x AS4C256M16D3A-12BIN Alliance DDR3 - 1 GB (32 data bits)
  * Quad SPI FLASH: S25FL128SAGNFI011 (128 MB, 133MHz)
  * SD/SDIO
  * 1 x User Push Button (SRST)
  * GigaBit Ethernet
  * USB OTG
  * 2 x I2C
  * 1 x SPI (SPI0)
  * RS-485 (UART1)
  * CAN
* Connected to PL part
  * User I/Os
    * 2 x User LEDs
    * 4 x Digital inputs
    * 4 x Digital outputs
    * 8 x GPIOs
  * UART (UART0 at PL)
  * HDMI
  * PCIe/104
  * 1 x VITA 57.1 FMC-HPC Connector
  * FAN
* JTAG/Debug
* JTAG Header
* Real Time Clock

## Power Supply

* +5V (center positive) must be provided at plug J1.

## Programming Options

* J6 could be used to connect an external JTAG cable (10 Position Receptacle Connector 0.050"/1.27mm).
* LPC11U35 (U17) provides JTAG (not supported by Vivado).

* The configuration source is controlled by a 2-position DIP switch at J7.

| Config. Source | J7.1 | J7.2 |
|----------------|------|------|
| JTAG           | OFF  | OFF  |
| QSPI           | OFF  | ON   |
| N/A            | ON   | OFF  |
| SD CARD        | ON   | ON   |
