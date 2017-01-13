#!/usr/bin/make

contributors:
	@git log --format='* %aN <%aE>' | LC_ALL=C.UTF-8 sort -uf > CONTRIBUTORS.md
