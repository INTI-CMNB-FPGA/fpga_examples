#!/usr/bin/make
#by RAM

DIRS=$(wildcard */)
DIRS:=$(filter-out resources/,$(DIRS))
DIRS:=$(filter-out ignore/,$(DIRS))

.PHONY: all prepare testbench bit clean

all: prepare testbench bit

prepare:
	@$(foreach DIR,$(DIRS),make -C $(DIR) prepare;)

testbench:
	@$(foreach DIR,$(DIRS),$(if $(wildcard $(DIR)testbench), make -C $(DIR)testbench;))

bit:
	@$(foreach DIR,$(DIRS),make -C $(DIR) bit;)

clean:
	@$(foreach DIR,$(DIRS),rm -fr $(DIR)temp;)
	@$(foreach DIR,$(DIRS),$(if $(wildcard $(DIR)testbench), make -C $(DIR)testbench clean;))
	@$(foreach DIR,$(DIRS),make -C $(DIR) clean-all;)
	@$(foreach DIR,$(DIRS),rm -fr $(DIR)*.bit;)
