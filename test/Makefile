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
GUILEFLAGS = -L $(top_srcdir) -X .sld
gsi = gsi
gsiflags = -:r7rs $(top_srcdir)

# dependencies
days := $(wildcard day/*)
data := $(wildcard data/*)
r7rs_deps := test-common.scm $(days) $(data)

# add red/green [FAIL]/[PASS] to output based on the words
# unexpected|ERROR/expected
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ expected / s/$$/ $(GREEN)[PASS]$(RESET)/'\
	    | sed '/unexpected/ s/$$/ $(RED)[FAIL]$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)[FAIL]$(RESET)/'
HANDLE_USRES := sed '/^ok/ s/.*/$(GREEN)[PASS]&$(RESET)/'\
	      | sed '/^not ok/ s/.*/$(RED)[FAIL]&$(RESET)/'\

############################################################
#			   Rules			   #
############################################################
#.PHONY: check clean help

help:  ## print this message
	grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

gauche-aoc-test: aoc-test.scm $(r7rs_deps) ## test against Gauche
	$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

