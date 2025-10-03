(define-library (aoc string)
  (cond-expand (guile (import (scheme base)
                              (scheme char)
                              (srfi srfi-1)))
               (else (import (scheme base)
                             (scheme char)
                             (only (srfi 1) every drop-while filter))))
  (export number-string? whitespace-string? strip-left stripped-string->number string->math commas->spaces
          delim->space parenthesize)
(begin
  (define (number-string? str)
    (every char-numeric? (string->list str)))

  (define (whitespace-string? str)
    (every char-whitespace? (string->list str)))

  (define (strip-left str)
    (list->string (drop-while char-whitespace? (string->list str))))

  (define (stripped-string->number str)
    (string->number (list->string (filter char-numeric? (string->list str)))))

  (define (string->math str)
    (if (number-string? str)
      (string->number str)
      (string->symbol str)))

  (define (commas->spaces str)
    (string-map (lambda (c) (if (char=? c #\,) #\space c)) str))

  (define (delim->space str delim-list)
    (string-map (lambda (c) (if (member c delim-list) #\space c)) str))

  (define (parenthesize str)
    (list->string (append `(#\() (string->list str) `(#\)))))

))
