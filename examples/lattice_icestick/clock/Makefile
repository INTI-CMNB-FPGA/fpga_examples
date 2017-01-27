#!/usr/bin/make

# Author: Bruno Valinoti
BOARD = icestick
LDIR = ../../../fpga_lib/verilog/verif/
NAME = top
FLAGS= -y$(LDIR)

#Project simulation
simu: $(NAME)_tb.vcd

#Project synthesis
run: $(NAME).bin

#FPGA bitstream programming
prog: $(NAME).bin
	iceprog $(NAME).bin


$(NAME)_tb.vcd: $(NAME)_tb.v $(NAME).v $(SOURCES1)
	iverilog $(NAME).v $(SOURCES1) $(NAME)_tb.v -o $(NAME)_tb.out	
	./$(NAME)_tb.out -lxt2

$(NAME).bin: $(BOARD).pcf $(NAME).v $(SOURCES1)
    #Synthesis
	yosys -p "synth_ice40 -blif $(NAME).blif" $(NAME).v $(SOURCES1)

	#Place & route
	arachne-pnr -d 1k -p $(BOARD).pcf $(NAME).blif -o $(NAME).txt

	#Binary generation
	icepack $(NAME).txt $(NAME).bin


SOURCES1=$(wildcard $(LDIR)/*.v)

clean:
	rm -f *.bin *.txt *.blif *.out 
