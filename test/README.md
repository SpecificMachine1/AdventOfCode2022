# Testing Framework
Makefile-based framework to test against various implementations of r7rs. Currently, Gauche is what is I'm using.


To add another implementation:
1. If the interpreter and flags section doesn't already contain the correct info, add this info
2. Add a target, with a short documentation section on the first line, proceeded by ##
3. Add a `cond-expand` section for this implementation in aoc-test.scm


To add new tests:
1. Make sure the library is imported in aoc-test.scm
2. Write the tests in srfi-64 form in test-common.scm
3. Run the tests by making the target(s) of interest, results may automatically stored as logfiles or you may have to do that through the Makefile
