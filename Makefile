#!/usr/bin/make
#by RAM

EXAMPLES=$(wildcard examples/*/)

.PHONY: clean submodule contributors

clean:
	@$(foreach EXAMPLE,$(EXAMPLES),$(if $(wildcard $(EXAMPLE)Makefile), make -C $(EXAMPLE) clean;))

submodule:
	@git submodule update --init; git submodule foreach 'git checkout master; git pull'

contributors:
	@git log --format='* %aN <%aE>' | LC_ALL=C.UTF-8 sort -uf > CONTRIBUTORS.md
