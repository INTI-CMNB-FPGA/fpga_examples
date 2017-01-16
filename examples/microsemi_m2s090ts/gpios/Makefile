#!/usr/bin/make
#
# Makefile for Synthesis with Tcl files (FPGA Helpers)
# Copyright (C) 2016-2017 INTI, Rodrigo A. Melo
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

PATH_VENDOR_TCL=../../../synthesis

ifneq ("$(wildcard $(PATH_VENDOR_TCL)/ise.tcl)","")
   TOOL = ise
else ifneq ("$(wildcard $(PATH_VENDOR_TCL)/vivado.tcl)","")
   TOOL = vivado
else ifneq ("$(wildcard $(PATH_VENDOR_TCL)/quartus2.tcl)","")
   TOOL = quartus2
else ifneq ("$(wildcard $(PATH_VENDOR_TCL)/libero-soc.tcl)","")
   TOOL = libero-soc
else
   $(error You need to have at least one <vendorTool>.tcl file)
endif

ifeq      ($(TOOL),ise)
else ifeq ($(TOOL),vivado)
else ifeq ($(TOOL),quartus2)
else ifeq ($(TOOL),libero-soc)
else
   $(error TOOL is unsupported [ise, vivado, quartus2, libero-soc])
endif

TASK=bit
ifeq      ($(TASK),syn)
else ifeq ($(TASK),imp)
else ifeq ($(TASK),bit)
else
   $(error TASK is unsupported [syn, imp, bit])
endif

OPT=user
ifeq      ($(OPT),user)
else ifeq ($(OPT),area)
else ifeq ($(OPT),power)
else ifeq ($(OPT),speed)
else
   $(error OPT is unsupported [user, area, power, speed])
endif

###############################################################################

TCL_FILE             = $(PATH_VENDOR_TCL)/$(TOOL).tcl
BIT_FILE             = $(shell find -type f -name '*.bit' -o -name '*.sof' -o -name '*.pof' -o -name '*.ipd')

# ISE - Xilinx

ise_TCL              = xtclsh $(TCL_FILE)
ise_TCL_CON          = xtclsh
ise_GUI              = ise ise.xise
ise_CLEAN            = iseconfig _ngo xst xlnx_auto_0_xdb _xmsgs *.bgn *.bld  \
                       *.cmd_log *.csv *.drc *.gise *.html *.log *.lso *.map  \
                       *.mrp *.ncd *.ngc *.ngd *.ngm *.ngr *.pad *.par *.pcf  \
                       *.prj *.ptwx *.stx *.syr *.twr *.twx *.unroutes *.ut   \
                       *.txt *.xml *.xpi *.xrpt *.xst *.xwbt
ise_CLEAN_ALL        = $(ise_CLEAN) ise.xise

# Vivado - Xilinx

vivado_TCL           = vivado -mode batch -notrace -source $(TCL_FILE) -tclargs
vivado_TCL_CON       = vivado -mode tcl
vivado_GUI           = vivado vivado.xpr
vivado_CLEAN         = .Xil *.cache *.hw *.ip_user_files *.jou *.log *.rpt    \
                       *.runs *.sim *.srcs vivado_*.zip
vivado_CLEAN_ALL     = $(vivado_CLEAN) vivado.xpr

# Quartus2 - Intel (Altera)

quartus2_TCL         = quartus_sh --script $(TCL_FILE)
quartus2_TCL_CON     = quartus_sh -s
quartus2_GUI         = quartus quartus2.qpf
quartus2_CLEAN       = db incremental_db output_files *.done *.jdi *.log *.pin\
                       *.qws *.rpt *.sld *.sof *.sop *.summary *.txt
quartus2_CLEAN_ALL   = $(quartus2_CLEAN) quartus2.qpf quartus2.qsf

# Libero-SoC - Microsemi (Actel)

libero-soc_TCL       = libero SCRIPT:$(TCL_FILE) SCRIPT_ARGS:"
libero-soc_END       = "
libero-soc_TCL_CON   = @echo console target not supported on Libero-SoC
libero-soc_GUI       = libero libero-soc/libero-soc.prjx
libero-soc_CLEAN     = libero-soc
libero-soc_CLEAN_ALL = $(libero-soc_CLEAN)

# Assign according to the selected tool

TCL_CMD              = $($(TOOL)_TCL)
TCL_END              = $($(TOOL)_END)
TCL_CON              = $($(TOOL)_TCL_CON)
GUI_CMD              = $($(TOOL)_GUI)
CLEAN                = $($(TOOL)_CLEAN)
CLEAN_ALL            = $($(TOOL)_CLEAN_ALL) $(BIT_FILE)

###############################################################################

all help:
	@echo "Options:"
	@echo "* TOOL: ise [default], vivado, quartus2."
	@echo "* TASK: syn, imp, bit [default]."
	@echo "* OPT:  user [default], area, power, speed."
	@echo "Targets:"
	@echo "* run:         run TASK with the OPTimization using the selected TOOL."
	@echo "* clean:       to delete generated files (excluding project and bitstream files)."
	@echo "* clean-all:   to delete all the generated files."
	@echo "* clean-multi: to delete generated files for all the vendors."
	@echo "* console:     to lunch the Tcl Console of the vendor Tool."
	@echo "* gui:         to lunch the Gui of the vendor Tool."
	@echo "If fpga_prog installed:"
	@echo "* prog-fpga and others (according to the specified board) for programming."

run:
	$(TCL_CMD) -task $(TASK) -opt $(OPT) $(TCL_END)

clean:
	@rm -fr $(CLEAN)

clean-all:
	@rm -fr $(CLEAN_ALL)

clean-multi:
	@rm -fr $(ise_CLEAN_ALL)
	@rm -fr $(vivado_CLEAN_ALL)
	@rm -fr $(quartus2_CLEAN_ALL)

console:
	$(TCL_CON)

gui:
	$(GUI_CMD)

###############################################################################

ifneq ($(shell which fpga_prog),)

prog-fpga:
	fpga_prog --tool=$(TOOL) --board=microsemi_m2s090ts-eval-kit --device=fpga $(firstword $(BIT_FILE))
prog-spi:
	fpga_prog --tool=$(TOOL) --board=microsemi_m2s090ts-eval-kit --device=spi  $(firstword $(BIT_FILE))

endif

# Generated with FPGA Synt (FPGA Helpers) v0.2.0
