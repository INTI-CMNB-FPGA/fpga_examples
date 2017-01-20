#!/usr/bin/make

submodule:
	@git submodule update --init; git submodule foreach 'git checkout master; git pull'

contributors:
	@git log --format='* %aN <%aE>' | LC_ALL=C.UTF-8 sort -uf > CONTRIBUTORS.md
