#!/usr/bin/make
#
# Makefile for Synthesis with Tcl files (FPGA Helpers)
# Copyright (C) 2016 INTI, Rodrigo A. Melo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

PATH_VENDOR_TCL=../../../synthesis

ifneq ("$(wildcard $(PATH_VENDOR_TCL)/ise.tcl)","")
   TOOL = ise
else ifneq ("$(wildcard $(PATH_VENDOR_TCL)/vivado.tcl)","")
   TOOL = vivado
else ifneq ("$(wildcard $(PATH_VENDOR_TCL)/quartus2.tcl)","")
   TOOL = quartus2
else
   $(error You have to have at least one <vendorTool>.tcl file)
endif

TCL_FILE           = $(PATH_VENDOR_TCL)/$(TOOL).tcl

ISE_TCL            = xtclsh $(TCL_FILE)
ISE_TCL_CON        = xtclsh
ISE_GUI            = ise ise.xise
ISE_CLEAN          = iseconfig _ngo xst xlnx_auto_0_xdb _xmsgs *.bgn *.bld  \
                     *.cmd_log *.csv *.drc *.gise *.html *.log *.lso *.map  \
                     *.mrp *.ncd *.ngc *.ngd *.ngm *.ngr *.pad *.par *.pcf  \
                     *.prj *.ptwx *.stx *.syr *.twr *.twx *.unroutes *.ut   \
                     *.txt *.xml *.xpi *.xrpt *.xst *.xwbt
ISE_CLEAN_ALL      = $(ISE_CLEAN) *.xise

VIVADO_TCL         = vivado -mode batch -notrace -source $(TCL_FILE) -tclargs
VIVADO_TCL_CON     = vivado -mode tcl
VIVADO_GUI         = vivado vivado.xpr
VIVADO_CLEAN       = .Xil *.cache *.hw *.ip_user_files *.jou *.log *.rpt    \
                     *.runs *.sim *.srcs vivado_*.zip
VIVADO_CLEAN_ALL   = $(VIVADO_CLEAN) *.xpr

QUARTUS2_TCL       = quartus_sh --script $(TCL_FILE)
QUARTUS2_TCL_CON   = quartus_sh -s
QUARTUS2_GUI       = quartus quartus2.qpf
QUARTUS2_CLEAN     = db incremental_db output_files *.done *.jdi *.log *.pin\
                     *.qws *.rpt *.sld *.sof *.sop *.summary *.txt
QUARTUS2_CLEAN_ALL = $(QUARTUS2_CLEAN) *.qpf *.qsf

ifeq ($(TOOL),ise)
   TCL_CMD   = $(ISE_TCL)
   TCL_CON   = $(ISE_TCL_CON)
   GUI_CMD   = $(ISE_GUI)
   CLEAN     = $(ISE_CLEAN)
   CLEAN_ALL = $(ISE_CLEAN_ALL)
else ifeq ($(TOOL),vivado)
   TCL_CMD   = $(VIVADO_TCL)
   TCL_CON   = $(VIVADO_TCL_CON)
   GUI_CMD   = $(VIVADO_GUI)
   CLEAN     = $(VIVADO_CLEAN)
   CLEAN_ALL = $(VIVADO_CLEAN_ALL)
else ifeq ($(TOOL),quartus2)
   TCL_CMD   = $(QUARTUS2_TCL)
   TCL_CON   = $(QUARTUS2_TCL_CON)
   GUI_CMD   = $(QUARTUS2_GUI)
   CLEAN     = $(QUARTUS2_CLEAN)
   CLEAN_ALL = $(QUARTUS2_CLEAN_ALL)
else
   $(error TOOL is unsupported [ise, vivado, quartus2])
endif

BITFILE = $(shell find -type f -name '*.bit' -o -name '*.sof' -o -name '*.pof')

###############################################################################

all help:
	@echo "Help:"
	@echo "* Main targets:"
	@echo "  * syn: synthesis"
	@echo "  * imp: implementation"
	@echo "  * bit: bitstream"
	@echo "* Optimized variations:"
	@echo "  * syn-area, syn-power, syn-speed"
	@echo "  * imp-area, imp-power, imp-speed"
	@echo "  * bit-area, bit-power, bit-speed"
	@echo "* When fpga_prog installed"
	@echo "  * prog-fpga and others according to the specified board"
	@echo "* Others:"
	@echo "  * clean:       to delete generated files (excluding project files)"
	@echo "  * clean-all:   to delete all the generated files"
	@echo "  * clean-multi: to delete generated files for all the vendors"
	@echo "  * console:     to lunch the Tcl Console of the vendor Tool"
	@echo "  * gui:         to lunch the Gui of the vendor Tool"
	@echo "* Tools:"
	@echo "  * To specify use TOOL=<vendorTool> when do make"
	@echo "  * The supported vendorTool values are: ise, vivado, quartus2"

syn:
	$(TCL_CMD) -run syn
syn-area:
	$(TCL_CMD) -run syn -opt area
syn-speed:
	$(TCL_CMD) -run syn -opt speed
syn-power:
	$(TCL_CMD) -run syn -opt power

imp:
	$(TCL_CMD) -run imp
imp-area:
	$(TCL_CMD) -run imp -opt area
imp-speed:
	$(TCL_CMD) -run imp -opt speed
imp-power:
	$(TCL_CMD) -run imp -opt power

bit:
	$(TCL_CMD) -run bit
bit-area:
	$(TCL_CMD) -run bit -opt area
bit-speed:
	$(TCL_CMD) -run bit -opt speed
bit-power:
	$(TCL_CMD) -run bit -opt power

clean:
	@rm -fr $(CLEAN)

clean-all:
	@rm -fr $(CLEAN_ALL)

clean-multi:
	@rm -fr $(ISE_CLEAN_ALL)
	@rm -fr $(VIVADO_CLEAN_ALL)
	@rm -fr $(QUARTUS2_CLEAN_ALL)

console:
	$(TCL_CON)

gui:
	$(GUI_CMD)

###############################################################################

ifneq ($(shell which fpga_prog),)

prog-bpi:
	fpga_prog --tool=$(TOOL) --board=xilinx_ml605 --device=bpi  $(firstword $(BITFILE))
prog-fpga:
	fpga_prog --tool=$(TOOL) --board=xilinx_ml605 --device=fpga $(firstword $(BITFILE))

endif

# Generated with FPGA Synt (FPGA Helpers) v0.1.1

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

