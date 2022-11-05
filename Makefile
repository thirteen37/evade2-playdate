.PHONY: run build clean

run: build
	open *.pdx

build: evade2.pdx

clean:
	rm -rf *.pdx

%.pdx: source/*.lua
	pdc source $@
