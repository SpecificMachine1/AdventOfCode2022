# Testing Framework
[Makefile](https://www.gnu.org/software/make/manual/html_node/index.html)-based framework to test against various implementations of r7rs. Currently, Gauche is what is I'm using.


To add another implementation:
1. If the interpreter and flags section doesn't already contain the correct info, add this info
2. Add a target, with a short documentation section on the first line, proceeded by ##
3. Add a `cond-expand` section for this implementation in aoc-test.scm


To add new tests:
1. Make sure the library is imported in aoc-test.scm
2. Write the tests in [srfi-64](https://srfi.schemers.org/srfi-64/srfi-64.html) form in test-common.scm
3. Run the tests by making the target(s) of interest, results may automatically stored as logfiles or you may have to do that through the Makefile


Notes: 
- Added a runner to get uniform output in [csv](https://en.wikipedia.org/wiki/Comma-separated_values) format for tests. This doesn't work for Gambit since it's SRFI-64 is just an alias for a much simpler system that doesn't support custom runners. Also took stderr off pipeline to clean up csv.
