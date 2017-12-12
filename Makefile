%.pdf: %.tex
	lualatex -interaction=nonstopmode $<

%.svg: %.pdf
	pdf2svg $< $@

GARBAGE := *.pdf *.svg *.aux *.log *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.run.xml *.tdo *.fmt *.out *.auxlock *.synctex\(busy\) *.toc tikz/*.log
clean:
	rm -f $(GARBAGE)
.PHONY: clean
