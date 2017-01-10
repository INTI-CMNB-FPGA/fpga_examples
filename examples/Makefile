#!/usr/bin/make
#by RAM

DIRS=$(wildcard */)

.PHONY: clean

clean:
	@$(foreach DIR,$(DIRS),$(if $(wildcard $(DIR)Makefile), make -C $(DIR) clean;))
