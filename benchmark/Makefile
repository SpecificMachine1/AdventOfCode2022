############################################################
#			 Variables			   #
############################################################

# environment
top_srcdir = $(abspath ../)
SHELL := bash
VPATH := .:..
guile-cache := $(HOME)/.cache/guile/ccache/3.0-LE-8-4.7$(top_srcdir)
go-files := $(shell find $(guile-cache) -name '*.go')

# interpreters and flags
GOSH = gosh
GOSHFLAGS = -I $(top_srcdir) -I .
CHIBISHCEME = chibi-scheme
CHIBISHCEMEFLAGS = -I $(top_srcdir) 
GUILE = guile
SLOWGUILEFLAGS = -L . -L .. --no-auto-compile -x .sld
FASTGUILEFLAGS = -L . -L .. -x .sld 
FASTESTGUILEFLAGS = -L . -L .. -O9 -x .sld # according to the manual this works, so far, it hasn't
gsi = gsi
gsiflags = -:r7rs,debug=- . ..

# dependencies
days := $(wildcard day/*)
data := $(wildcard data/*)
r7rs_deps := $(days) $(data)

guiledays := $(wildcard guilesrc/day*)
guile_deps := $(guiledays) $(data)

gambitdays := guilesrc/1.sld guilesrc/2.sld guilesrc/3.sld guilesrc/4.sld guilesrc/5.sld \
              guilesrc/6.sld
gambit_deps := $(gambitdays) $(data)

############################################################
#			   Rules			   #
############################################################

.PHONY: test clean-guile-cache

help:  ## print this message
	grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

gauche-bench.csv: profile-solutions.scm $(r7rs_deps) $(profiler)
	$(GOSH) $(GOSHFLAGS) $< | tee gauche-bench.csv

guile-bytecode: load-to-compile.scm $(guile_deps) ## bytecode compile guile files
	$(GUILE) $(FASTGUILEFLAGS) $<

.ONESHELL:
clean-guile-cache: ## remove guile
	cd $(guile-cache)
	$(RM) $(go-files)

test:
	echo $(go-files)
