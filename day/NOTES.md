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

- I am going to try to use some of the features I am less familiar with in the core language
this year (2025 :joy:) like continuations, macros, parameters, force & promise, environments,
etc. So far I've used call/cc to pass an escape t a search function that was in a fold
