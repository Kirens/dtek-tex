default: install

installdir = $(shell kpsewhich --var-value TEXMFHOME)/tex/latex/dtek

install:
	mkdir -p $(installdir)
	cp src/* $(installdir)
