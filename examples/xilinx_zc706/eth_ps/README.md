# Description

Examples about how to send a large quantity of data through Ethernet (TCP and UDP).

Only the PS part of a Zynq device is used.

# How to run synthesis, implementation and programming

* For the used FPGA, Vivado System Edition with a valid license is needed.
* Prepare the environment to use Vivado. For example, run:
```
$ . /PATH_TO_VIVADO/settings64.sh
```
* Open Vivado and create a new proyect for: ZYNQ-7 ZC706 Evaluation Board.
* In Tcl Console, run (block designs generated with Vivado 2018.2): `source <PATH>/eth_ps.tcl`
* Rigth click in Sources -> Design Sources -> design_1 and Create HDL Wrapper.
* Right click over design_1_i and select *Generate Output products*.
* **NOTE:** synthesis, implementation and the bitstream are not needed (only the PS part is used).
* File -> Export -> Export Hardware (exclude bitstream)
* Launch SDK
* Generate a new Application Project:
  * OS Platform: freertos10_xilinx
  * Template: FreeRTOS LwIP Echo Server
* Remove under *Project Name*, *src* directory, the files *echo.c* and *main.c*.
* Import to *src* directory:
  * For TCP: `<ROOT>/shared/zynq7000/tcp_echo.c`
  * For UDP: `<ROOT>/shared/zynq7000/udp_echo.c`
* Configure SDK terminal (or another terminal program) with the needed Port to see UART Output (J21 - USB UART).
* Rigth Click over polled project -> Run As -> Launch on hardware.

# How to test on hardware

* Connect a PC *eth* (configured as IP=192.168.0.1, MASK=255.255.255.0, GW=192.168.0.10) to the board Ethernet port.
* You can check the connection and see debug info in the terminal.
* Run `python3 <ROOT>/shared/soft/eth_echo.py --help` for options and:
  * For TCP: `python3 <ROOT>/shared/soft/eth_echo.py`
  * For UDP: `python3 <ROOT>/shared/soft/eth_echo.py -u`
