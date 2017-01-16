# Virtex-6 FPGA ML605 Evaluation Kit

## Useful documents

* ML605 Hardware User Guide (UG534)

## Features

* Xilinx FPGA XC6VLX240T-1FFG1156 (Virtex 6 LXT with speed grade -1)
* 512 MB DDR3 Memory SODIMM -> MT4JSF6464HY-1G1B1
* 128 Mb Xilinx XCF128X-FTG64C Platform Flash XL
* Numonyx JS28F256P30 32MB Linear BPI Flash memory
* System ACE CF and CompactFlash Connector (with a ULTRA CF of 2GB)
* Clock sources:
  * 2.5V LVDS differential 200 MHz oscillator
    * Crystal oscillator: SiTime SiT9102AI-243N25E200.00000
    * Frequency stability: 50 ppm
  * Oscillator Socket (Single-Ended, 2.5V) 
    * Populated with a 66 MHz 2.5V single-ended MMD Components MBH2100H-66.000 MHz oscillator
  * SMA Connectors (Differential)
    * Onboard 50 Ohm SMA connectors
  * GTX SMA Clock
    * Onboard 50 Ohm SMA connectors
* Access to 20 Multi-Gigabit Transceivers (GTX MGTs)
  * 8 of the MGTs are wired to the PCIe x8 Endpoint edge connector fingers
  * 8 of the MGTs are wired to the FMC HPC connector
  * 1 MGT is wired to SMA connectors
  * 1 MGTs is wired to the FMC LPC connector
  * 1 MGT is wired to the SFP Module connector
  * 1 MGT is used for an SGMII connection to the Ethernet PHY
* 10/100/1000 Tri-Speed Ethernet PHY -> Marvell Alaska PHY device (88E1111)
* USB-to-UART Bridge -> Silicon Labs CP2103GM
* USB Controller -> Cypress CY7C67300 EZ-Host
* DVI Codec -> Chrontel CH7301C capable of 1600 X 1200 resolution with 24-bit color
* IIC Bus
* User I/O
  * User LEDs (8) with parallel wired GPIO male pin header
  * User Pushbutton (5) switches with associated direction LEDs
  * CPU Reset pushbutton switch
  * User DIP switch (8-pole)
  * User SMA GPIO
  * LCD Display (16 char x 2 lines)
* VITA 57.1 FMC HPC Connector
* VITA 57.1 FMC LPC Connector

## Power Supply

* 12V through a 6-pin (2X3) right-angle Mini-Fit type connector J60.
* When in PC (PCIe slot), is tipically powered with the ATX hard disk type 4-pin power connectors (plugged into connector J25).

Caution:
* DO NOT apply power to J60 and the 4-pin ATX disk drive connector J25 at the same time.
* DO NOT plug a PC ATX power supply 6-pin connector into ML605 connector J60 (has a different pinout).

## Programming Options

Jtag chain:
* Through a Type-A (computer host side) to Type-Mini-B J22 (ML605 side) USB cable.
* Put Jumpers between pins 1-2 of J17 and J18 to bypass FMC. In this manner FPGA will be part 2 on the chain.

DIP Switch S1:
* S1.4:
  * ON: allows the System ACE to boot at power-on if it finds a CF card present.
  * OFF: boot from BPI Flash U4 or Xilinx Platform Flash (U27) without System ACE contention.

DIP Switch S2:
* S2.1: CCLK External (enables 47 MHz for BPI)
* S2.2: P30_CS_SEL    (select betbeen Xilinx Platform Flash or BPI)
* S2.3: FPGA_M0
* S2.4: FPGA_M1
* S2.5: FPGA_M2
* S2.6: FLASH_A23     (select upper or lower half of BPI)

To program/boot from (when memories):
* FPGA:
  * S2.5..3 (M2, M1, M0) = 101
* System ACE:
  * CompactFlash inserted
  * S1.4 = ON
  * S2.1 = OFF, S2.2 = ON, S2.5..3 = 101, S2.6 = OFF
* BPI:
  * S1.4 = OFF
  * S2.1 = OFF, S2.2 = ON, S2.5..3 = 010, S2.6 = ON/OFF
* Platform Flash XL:
  * S1.4 = OFF
  * S2.1 = ON, S2.2 = OFF, S2.5..3 = 110, S2.6 = don't care
