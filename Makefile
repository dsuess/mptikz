TIKZFILES := $(wildcard *.tex)
all: $(TIKZFILES:%.tex=%.svg)
	echo "Done"
.PHONY: all

%.pdf: %.tex mptikz.sty
	lualatex -interaction=nonstopmode $<

%.svg: %.pdf
	pdf2svg $< $@

GARBAGE := *.pdf *.svg *.aux *.log *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.run.xml *.tdo *.fmt *.out *.auxlock *.synctex\(busy\) *.toc tikz/*.log
clean:
	rm -f $(GARBAGE)
.PHONY: clean
