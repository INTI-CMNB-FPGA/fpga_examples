#!/usr/bin/make

TOOL=vivado
TCLPATH=../../../fpga_helpers/tcl
include $(TCLPATH)/Makefile

COREGEN := $(shell command -v vivado 2> /dev/null)
prepare:
ifneq ($(COREGEN),)
	mkdir -p temp
	cp ../resources/gbt1.* temp
	cd temp; vivado -mode batch -notrace -quiet -source gbt1.tcl
else
	@echo "ERROR: vivado not found."
	@echo "Please prepare the environment running something like:"
	@echo "$ . /PATH_TO_VIVADO/settings64.sh"
	@echo "Note: this design needs Vivado Design Suite with support and a valid license for Zynq 7045."
endif

