;; SPDX-License-Identifier: AGPL-3.0-or-later
;; day-1.scm solutions for day one
;; Copyright © 2022 Felix Thibault
(import (scheme base)
	(scheme file)
	(srfi 115))

;; Port -> List of List of Numbers
(define (get-data port)
  (let lp ((line (read-line port)) (this '()) (all '()))
    (cond
      ((eof-object? line) (cons this all))
      ((regexp-matches? '(* white) line) (lp (read-line port)
					     '()
					     (cons this all)))
      (else (lp (read-line port)
		(cons (string->number line) this)
		all)))))

(get-data (open-input-file "../data/day1-example1.dat"))

;; [List-of [List-of Numbers]] -> Number
(define (most-calories packs)
  (let lp ((packs packs) )))
