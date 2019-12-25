NAME=propuesta

TEXFILES=${NAME}.tex $(shell ./tex-dependencies $(NAME).tex)
BIBFILES=${NAME}.bib
PDF_T=$(shell ./strip-dependence inputfig $(TEXFILES))
VERBATIM=$(shell ./strip-dependence verbatimtabinput $(TEXFILES))
CODEFILES=$(shell ./strip-dependence inputcode $(TEXFILES))
PDF=$(subst .pdf_t,.pdf,$(PDF_T))

all: $(NAME).pdf

%.pdf: %.fig
	fig2dev -Lpdftex -m 0.75 $< $@

%.pdf_t: %.fig %.pdf
	fig2dev -Lpdftex -m 0.75 -p $(basename $<).pdf $< $@

%.code: %.java
	./codify $<

$(NAME).pdf: $(TEXFILES) $(PDF) $(PDF_T) $(VERBATIM) $(CODEFILES) $(BIBFILES)
	pdflatex $<
	makeindex $(NAME)
	bibtex $(NAME)
	pdflatex $<
	pdflatex $<

view: $(NAME).pdf
	xpdf $<

clean:
	rm -f *.aux *.log *~ propuesta.pdf *.pdf_t *.bbl *.blg

spotless: clean
	rm -f *.ps *.dvi propuesta.pdf *.pdf_t *.toc *.idf *.ilg *.ind *.fig.bak
	rm -f *.out *.cb *.cb2
