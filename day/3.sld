;; SPDX-License-Identifier: AGPL-3.0-or-later
;; day-1.scm solutions for day one
;; Copyright © 2022 Specific Machine
(define-library (day 3)
  (export )
  (import (scheme base)
    (scheme file))

  (begin
    #|
    A Rucksack contains:
      a vector with all the characters in a sack
  a hash-table that represents each compartment
    |#
    (define-record-type Rucksack
      (rucksack vec table)
      rucksack?
      (vec get-vec)
      (table get-table))

    ;;get-data-3 string -> [List-of [Vector-of Characters]]
    ;;this function reads data from the file that represents each rucksack
    ;;into vectors of characters
    (define (get-data-3 filename)
      (call-with-input-file
        filename
        (lambda (port)
          (let lp ((line (read-line port))
                   (out '()))
            (if (eof-object? line)
              out
              (lp (read-line port) (cons (string->vector line) out)))))))

    (get-data-3 "./data/day3-example1.dat")

    (define (make-rucksack
