#!/usr/bin/make

TOOL=ise
TCLPATH=../../../fpga_helpers/tcl
include $(TCLPATH)/Makefile

COREGEN := $(shell command -v coregen 2> /dev/null)
prepare:
ifneq ($(COREGEN),)
	mkdir -p temp
	cp ../resources/coregen.cgp ../resources/gbt3.xco temp
	cp ../resources/mmcm200to150.xco ../resources/mmcm150and75.xco temp
	coregen -p temp/coregen.cgp -b temp/gbt3.xco
	coregen -p temp/coregen.cgp -b temp/mmcm200to150.xco
	coregen -p temp/coregen.cgp -b temp/mmcm150and75.xco
	rm coregen.log
else
	@echo "ERROR: coregen not found."
	@echo "Please prepare the environment running something like:"
	@echo "$ . /PATH_TO_ISE/ISE_DS/settings64.sh"
	@echo "Note: this design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240."
endif

