- Since the data is always a text file, my first procedures always look like:
```scheme
(define (get-data filename)
  (call-with-input-file
    filename
    (lambda (port)
      (let lp ((this (read/read-char/read-line port) ...)
        (cond
          ((eof-object? this) ...)
          ...
          (else (lp ((read/read-char/read-line port) ...)
```
Someone mentioned transducers, and I may look at them but honestly any srfi
over 100 is iffy- I had to re-write all my regex-based solutions here to get
Gambit and Guile to run (although it did result in a speed up) 


- So far it doesn't seem like there is an ongoing theme, like there was with intcode, but
then I think that might have started around puzzle seven, so who knows. 

- But it does seem like one thing that has turned out to be a regular theme, especially since day 5, has been transforming the file into a data structure in multiple passes. Also I finally worked out how to generalize reading in the file, with parameters, which I have used a few times for refactoring now. When I look around at how other people use them one thing I notice is the with/current pattern, where there is a with- function that parameterizes some current- value.

- I am going to try to use some of the features I am less familiar with in the core language
this year (2025 :joy:) like continuations, macros, parameters, force & promise, environments,
etc. So far I've used call/cc to pass an escape to a search function that was in a fold, macros
in code outside of the main code (testing and benchmarking), parameters I've used a bit in refactoring, and there was one problem (Day 11) when eval was part of the solution, so I used environments.

- Helpful links:
  - [r7rs small](https://standards.scheme.org/unofficial/errata-corrected-r7rs.pdf)
  - [r7rs large red](https://codeberg.org/scheme/r7rs/src/branch/main/ballot-results/jcowan/edition/2016-07-red-edition-report.md) - not using this as much this year since it makes solutions less portable
  - [Gauche Manual](https://practical-scheme.net/gauche/man/gauche-refe/index.html)
  - [Advent of Code 2022](https://adventofcode.com/2022)
