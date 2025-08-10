;; SPDX-License-Identifier: AGPL-3.0-or-later
;; day-1.scm solutions for day one
;; Copyright © 2022 Specific Machine
(define-library (guilesrc day1)
  (export get-data most-calories calories-of-top-three)
  (import (scheme base)
	  (scheme file)
          (scheme char)
	  (only (srfi srfi-1) every))

  (begin

;;https://adventofcode.com/2022/day/1
    ;; Port -> List of List of Numbers
    (define (get-data port)
      (let lp ((line (read-line port)) (this '()) (all '()))
	(cond
	  ((eof-object? line) (cons this all))
	  ((every char-whitespace? (string->list  line))
           (lp (read-line port) '() (cons this all)))
	  (else (lp (read-line port)
		    (cons (string->number line) this)
		    all)))))

    ;(get-data (open-input-file "../data/day1-example1.dat"))

    ;; [List-of [List-of Numbers]] -> Number
    (define (most-calories packs)
      (let lp1 ((packs packs) (greatest 0))
	(if (null? packs)
	  greatest
	  (let lp2 ((pack (car packs)) (sum 0))
	    (if (null? pack)
	      (if (> sum greatest)
		(lp1 (cdr packs) sum)
		(lp1 (cdr packs) greatest))
	      (lp2 (cdr pack) (+ sum (car pack))))))))
    #|
    code for testing solution to first problem
    (most-calories
      (get-data (open-input-file "../data/day1-example1.dat")))

    (most-calories
      (get-data (open-input-file "../data/day1-input.dat")))
    |#

    ;; [List-of [List-of Numbers]] -> [List-of Number]
    (define (calories-of-top-three packs)
      (let lp1 ((packs packs) (first 0) (second 0) (third 0))
	(if (null? packs)
	  (list first second third)
	  (let lp2 ((pack (car packs)) (sum 0))
	    (if (null? pack)
	      (cond
		((> sum first) (lp1 (cdr packs) sum first second))
		((> sum second) (lp1 (cdr packs) first sum second))
		((> sum third) (lp1 (cdr packs) first second sum))
		(else (lp1 (cdr packs) first second third)))
	      (lp2 (cdr pack) (+ sum (car pack))))))))

    #|
    code to test second solution
    (fold + 0  (calories-of-top-three
		 (get-data (open-input-file "../data/day1-example1.dat"))))

    (fold + 0  (calories-of-top-three
		 (get-data (open-input-file "../data/day1-input.dat"))))
    |#
    ))
