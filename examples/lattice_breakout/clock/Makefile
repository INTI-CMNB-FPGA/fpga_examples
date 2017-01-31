#!/usr/bin/make

# Author: Bruno Valinoti

BOARD = breakout
LDIR = ../../../fpga_lib/verilog/verif/
NAME = top
FLAGS= -y$(LDIR)

#Project synthesis
run: $(NAME).bin

#FPGA bitstream programming
prog: $(NAME).bin
	iceprog $(NAME).bin


$(NAME).bin: $(BOARD).pcf $(NAME).v $(SOURCES1)
    #Synthesis
	yosys -p "synth_ice40 -blif $(NAME).blif" $(NAME).v $(SOURCES1)

	#Place & route
	arachne-pnr -d 8k -p $(BOARD).pcf $(NAME).blif -o $(NAME).txt

	#Binary generation
	icepack $(NAME).txt $(NAME).bin


SOURCES1=$(wildcard $(LDIR)/*.v)

clean:
	rm -f *.bin *.txt *.blif *.out 
