#!/usr/bin/make

# Author: Bruno Valinoti

BOARD = icestick
LDIR = ../../../../fpga_lib/verilog/verif
SDIR = ../
NAME = top
FLAGS= -I$(SDIR) -y$(LDIR)

#Project simulation
simu: $(NAME)_tb.vcd

#Open waveforms
view: $(NAME)_tb.vcd
	gtkwave $(NAME)_tb.vcd
	
$(NAME)_tb.vcd: $(NAME)_tb.v $(SOURCES2) $(SOURCES1)
	iverilog $(SOURCES2) $(SOURCES1) $(NAME)_tb.v -o $(NAME)_tb.out	
	./$(NAME)_tb.out -lxt2


SOURCES1=$(wildcard $(LDIR)/*.v)
SOURCES2=$(wildcard $(SDIR)/*.v)

clean:
	rm -f *.vcd *.out 
