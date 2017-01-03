#!/usr/bin/make

all: run

run top_tb:
	fuse work.top_tb -prj files.prj -L unisim -L secureip -timeprecision_vhdl fs -o top_tb

see: top_tb
	./top_tb -gui -tclbatch waves.tcl

clean:
	rm -fr isim *.wdb *.wcfg *.xmsgs *.log *.cmd top_tb
