.PHONY: run build publish clean

run: build
	open *.pdx

build: evade2.pdx

publish: evade2.zip

clean:
	rm -rf *.pdx

%.pdx: source/*.lua source/pdxinfo
	pdc source $@

%.zip: %.pdx
	rm -rf $@
	zip -r $@ $<
