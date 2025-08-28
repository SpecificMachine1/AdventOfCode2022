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
gscexeflags = -keep-temp -exe -nopreload 
gscmodflags = -keep-temp -module-ref

# dependencies
days := $(wildcard day/*)
data := $(wildcard data/*)
r7rs_deps := $(days) $(data)
profiler := profiler.sld
gscprofiler := benchmark/profiler.sld

guiledays := $(wildcard ports/day*)
guile_deps := $(guiledays) $(data)

gambitdays := ports/1.sld ports/2.sld ports/3.sld ports/4.sld ports/5.sld \
              ports/6.sld
gambit_deps := $(gambitdays) $(data)

gscdays_c := $(gambitdays:.sld=.c)
profiler_c := $(gscprofiler:.sld=.c)
gsc_deps :=  $(profiler_c) $(gscdays_c) gsc-bench.c


############################################################
#			   Rules			   #
############################################################

.PHONY: test clean-guile-cache clean all

help:  ## print this message
	grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: gauche-bench.csv gauche-ports-bench.csv guile-bench.csv gsi-bench.csv gsc-bench.csv ## run all benchmarks

gauche-bench.csv: profile-solutions.scm $(r7rs_deps) $(profiler) ## run benchmarks for original solutions in Gauche
	$(GOSH) $(GOSHFLAGS) $< | tee results/gauche-bench.csv

gauche-ports-bench.csv: profile-solutions-ports.scm $(guile_deps) $(profiler) ## run benchmarks for ported solutions in Gauche
	$(GOSH) $(GOSHFLAGS) $< | tee results/gauche-ports-bench.csv

guile-bench.csv: profile-solutions-ports.scm $(guile_deps) $(profiler) ## run ported benchmarks with Guile
	$(GUILE) $(FASTGUILEFLAGS) $< | tee results/guile-bench.csv

gsi-bench.csv: profile-solutions-ports.scm $(gambit_deps) $(profiler) ## run ported benchmarks with Gambit interpreter
	$(gsi) $(gsiflags) $< | tee results/gsi-bench.csv

gsc-bench.csv: gsc-bench ## output gambitc benchmarks
	./gsc-bench | tee results/gsc-bench.csv	

gsc-bench: $(gsc_deps) ## build gambitc benchmarks (builds but doesn't make output)
	$(gsc) $(gscexeflags) .  $(gsc_deps)

gsc-bench.c: gsc-bench.scm $(profiler_c) $(gscdays_c)
	$(gsc) -c .  $<

%.c: %.sld
	$(gsc) $(gscmodflags) $* -c .  $^

.ONESHELL:
clean-guile-cache: ## remove guile
	cd $(guile-cache)
	$(RM) $(go-files)

test:
	echo $(go-files)

clean:
	$(RM) results/*.csv
