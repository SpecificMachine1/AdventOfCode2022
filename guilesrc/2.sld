;; SPDX-License-Identifier: AGPL-3.0-or-later
;;
;; Copyright © 2022 Specific Machine
;; problem: https://adventofcode.com/2022/day/2
(define-library (guilesrc 2)
		(export get-data-2 score-games-2 score-games-2.1)
		(import (scheme base)
			(scheme file)
			(scheme read)
			(only (srfi 1) fold))
(begin
  (define (get-data-2 filename)
    (call-with-input-file
      filename
      (lambda (port)
	(let lp ((next (read port))
		 (first '())
		 (output '()))
	  (cond
	    ((eof-object? next) (reverse output))
	    ((null? first) (lp (read port) next output))
	    (else (lp (read port)
		      '()
		      (cons (list first next) output))))))))

;;  (get-data-2 "../data/day2-example1.dat")

(define (total-score game)
  (let ((opponent (car game))
	(self (cadr game)))
    (+ (material-score self) (game-score opponent self))))

(define (material-score mat)
  (cond
    ((eq? 'X mat) 1)

    ((eq? 'Y mat) 2)
    ((eq? 'Z mat) 3)))

(define (game-score opp self)
  (cond
    ((eq? opp 'A) (cond ((eq? self 'X) 3)
			 ((eq? self 'Y) 6)
			 ((eq? self 'Z) 0)) )
    ((eq? opp 'B) (cond ((eq? self 'X) 0)
			 ((eq? self 'Y) 3)
			 ((eq? self 'Z) 6)))
    ((eq? opp 'C) (cond ((eq? self 'X) 6)
			 ((eq? self 'Y) 0)
			 ((eq? self 'Z) 3)))))

(define (score-games-2 games)
  (fold + 0 (map total-score games)))

;;(score-games-2 (get-data-2 "../data/day2-example1.dat"))

;;(score-games-2 (get-data-2 "../data/day2-input.dat"))

;;Game Object <rock> | <paper> | <scissors>
;;            records used to represent game objects represented by
;;            A, B, and C in initial file

(define-record-type <rock>
  (rock)
  rock?)

(define-record-type <paper>
  (paper)
  paper?)

(define-record-type <scissors>
  (scissors)
  scissors?)

(define (symbol->game-object sym)
  (cond
    ((eq? sym 'A) (rock))
    ((eq? sym 'B) (paper))
    ((eq? sym 'C) (scissors))))

(define (game-object-points obj)
  (cond
    ((rock? obj) 1)
    ((paper? obj) 2)
    ((scissors? obj) 3)
    ))

;; Outcome <win> | <lose> | <draw>
(define-record-type <lose>
  (lose)
  lose?)

(define-record-type <draw>
  (draw)
  draw?)

(define-record-type <win>
  (win)
  win?)

(define (symbol->outcome sym)
  (cond
    ((eq? sym 'X) (lose))
    ((eq? sym 'Y) (draw))
    ((eq? sym 'Z) (win))))

(define (outcome-points obj)
  (cond
    ((lose? obj) 0)
    ((draw? obj) 3)
    ((win? obj) 6)
    ))

(define (outcome->score opp+out)
  (let* ((opponent (car opp+out))
	(outcome (cadr opp+out))
	(result (get-result outcome opponent)))
    (+ (outcome-points outcome)
       (game-object-points result))))

(define (score-games-2.1 games)
  (fold + 0 (map outcome->score
		 (map (lambda (sym+sym)
			(list (symbol->game-object (car sym+sym))
			      (symbol->outcome (cadr sym+sym))))
		      games))))

(define (get-result outcome opponent)
  (cond
    ((win? outcome) (cond
		      ((rock? opponent) (paper))
		      ((paper? opponent) (scissors))
		      ((scissors? opponent) (rock))))
    ((lose? outcome) (cond
		      ((rock? opponent) (scissors))
		      ((paper? opponent) (rock))
		      ((scissors? opponent) (paper))))
    ((draw? outcome) opponent)))

;;(score-games-2.1 (get-data-2 "../data/day2-example1.dat"))

;;(score-games-2.1 (get-data-2 "../data/day2-input.dat"))

))
