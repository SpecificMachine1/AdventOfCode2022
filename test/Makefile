# SPDX-License-Identifier: AGPL-3.0-or-later
# day-1.scm solutions for day one
# Copyright © 2022 Specific Machine

############################################################
#			 Variables			   #
############################################################

# environment
top_srcdir = $(abspath ../)
SHELL := bash
VPATH := .:..

# interpreters and flags
GOSH = gosh
GOSHFLAGS = -I $(top_srcdir)
CHIBISHCEME = chibi-scheme
CHIBISHCEMEFLAGS = -I $(top_srcdir) 
GUILE = guile
GUILEFLAGS = -L . -L .. -x .sld --no-auto-compile
gsi = gsi
gsiflags = -:r7rs,debug=- . ..

# dependencies
days := $(wildcard day/*)
data := $(wildcard data/*)
r7rs_deps := test-common.scm $(days) $(data)

guiledays := $(wildcard guilesrc/day*)
guile_deps := test-common.scm $(guiledays) $(data)

gambitdays := guilesrc/1.sld guilesrc/2.sld guilesrc/3.sld guilesrc/4.sld guilesrc/5.sld \
              guilesrc/6.sld
gambit_deps := test-common.scm $(gambitdays) $(data)

####################################### post-processing ###############################

# add red/green [FAIL]/[PASS] to output based on the words
# unexpected|ERROR/expected
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ pass / s/$$/ $(GREEN)pass$(RESET)/'\
	    | sed '/ fail / s/$$/ $(RED)fail$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)fail$(RESET)/'

#remove warnings after results
clean-after := sed '1,/^Passing tests:/!d'

############################################################
#			   Rules			   #
############################################################
#.PHONY: check clean help

help:  ## print this message
	grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: gauche-aoc-test guile-aoc-test gambit-aoc-test

gauche-aoc-test: aoc-test.scm $(r7rs_deps) ## test against Gauche
	$(GOSH) $(GOSHFLAGS) $< 2>&1 | tee test-logs/gauche.csv | $(HANDLE_RES)

guile-aoc-test: aoc-test.guile.scm $(guile_deps) ## test against Guile
	$(GUILE) $(GUILEFLAGS) $< 2>&1 | $(clean-after) | tee test-logs/guile.csv | $(HANDLE_RES)

gambit-aoc-test: aoc-test.scm $(gambit_deps) ## test against Gambit
	$(gsi) $(gsiflags) $< 2>&1 | tee test-logs/gambit.log | $(HANDLE_RES)
