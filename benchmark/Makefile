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
gsiflags = -:r7rs . ..
gsc = gsc
gscexeflags = -cc clang -exe -nopreload 
gscmodflags = -cc clang -module-ref

# dependencies
days := $(wildcard day/*)
data := $(wildcard data/*)
r7rs_deps := $(days) $(data)
profiler := profiler.sld
gscprfiler := benchmark/profiler.sld

guiledays := $(wildcard guilesrc/day*)
guile_deps := $(guiledays) $(data)

gambitdays := guilesrc/1.sld guilesrc/2.sld guilesrc/3.sld guilesrc/4.sld guilesrc/5.sld \
              guilesrc/6.sld
gambit_deps := $(gambitdays) $(data)

gscdays_c := $(gambitdays:.sld=.c)
profiler_c := $(gscprofiler:.sld=.c)
gsc_deps :=  $(profiler_c) $(gscdays_c) profile-solutions-guilesrc.c


############################################################
#			   Rules			   #
############################################################

.PHONY: test clean-guile-cache clean all

help:  ## print this message
	grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: gauche-bench.csv gauche-guilesrc-bench.csv guile-bench.csv gsi-bench.csv ## run all benchmarks

gauche-bench.csv: profile-solutions.scm $(r7rs_deps) $(profiler) ## run benchmarks for original solutions in Gauche
	$(GOSH) $(GOSHFLAGS) $< | tee gauche-bench.csv

gauche-guilesrc-bench.csv: profile-solutions-guilesrc.scm $(guile_deps) $(profiler) ## run benchmarks for ported solutions in Gauche
	$(GOSH) $(GOSHFLAGS) $< | tee gauche-guilesrc-bench.csv

guile-bench.csv: profile-solutions-guilesrc.scm $(guile_deps) $(profiler) ## run ported benchmarks with Guile
	$(GUILE) $(FASTGUILEFLAGS) $< | tee guile-bench.csv

guile-bytecode: load-to-compile.scm $(guile_deps) ## bytecode compile guile files
	$(GUILE) $(FASTGUILEFLAGS) $<

gsi-bench.csv: profile-solutions-guilesrc.scm $(gambit_deps) $(profiler) ## run ported benchmarks with Gambit interpreter
	$(gsi) $(gsiflags) $< | tee gsi-bench.csv

gsc-bench: $(gsc_deps) ## build gambitc benchmarks (builds but doesn't make output)
	$(gsc) $(gscexeflags) .  ..$(gsc_deps)

profile-solutions-guilesrc.c: profile-solutions-guilesrc.scm $(profiler_c) $(gscdays_c)
	$(gsc) -cc clang  -c . .. $<

%.c: %.sld
	$(gsc) $(gscmodflags) $* -c .  $^

.ONESHELL:
clean-guile-cache: ## remove guile
	cd $(guile-cache)
	$(RM) $(go-files)

test:
	echo $(go-files)

clean:
	$(RM) *.csv
