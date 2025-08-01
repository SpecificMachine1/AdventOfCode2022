(define-library (day 5)
  (import (scheme base)
          (scheme list)
          (scheme file)
          (srfi 130)
          (srfi 115)
          (scheme vector)
          (only (srfi 13) string-tokenize)
          (scheme write))
  (export get-data cj-get-stacks cj-get-instructions cj-get-stack-count run-job get-result
          run-job-2)
(begin
#|
Stacks are a group of stacks of crates refered to by numerical locations
  represented as a vector of lists of strings

Instructions tell the crane to pick up the crate on the top of one stack
and put it on top of another stack. They have the syntax
 mov Int from Int to Int

 and They are represented by <mov> structs

 mov count from to
  where count is a positive integer <= height of tallest stack
        from and to are indexes of the stacks

crane-job
  is a set of stakes of crates, together with the instructions on how to move
  them, stored in a struct


|#

(define-record-type <mov>
  (mov count from to)
  mov?
  (count mov-get-count)
  (from mov-get-from)
  (to mov-get-to))

(define-record-type <crane-job>
  (crane-job stacks instructions stack-count)
  crane-job?
  (stacks cj-get-stacks)
  (instructions cj-get-instructions)
  (stack-count cj-get-stack-count))

;; get-data Filename -> Stacks 
(define (get-data filename)
  (call-with-input-file 
    filename 
    (lambda (port)
        (define (process-lines port)
          (let ((index-line (regexp '(* (or numeric whitespace)))))
            (let lp ((line (read-line port))
                     (stacklines '())
                     (instrlines '())
                     (stack-count 1)
                     (mode 'stack))
              (cond
                ((eof-object? line)
                 (crane-job stacklines instrlines stack-count))
                ((and (eqv? mode 'stack) (regexp-matches? index-line line))
                 (let ((stacks (fold max 0 (map string->number (string-tokenize line)))))
                   (read-line port)
                   (lp (read-line port) stacklines instrlines (+ 1 stacks) 'inst)))
                ((eqv? mode 'inst)
                 (lp (read-line port) stacklines (cons line instrlines) stack-count mode))
                (else (lp (read-line port) (cons line stacklines) instrlines stack-count mode))))))
        (define (process-stacklines cj)
          (let* ((size (cj-get-stack-count cj))
                 (stacks (make-vector size '()))
                 (blank (regexp '(* whitespace))))
            (define (process-line line)
              (let lp ((left (string-append line " ")) (i 1))
                (cond
                  ((= i size) #t)
                  (else (let ((this (string-take left 3))
                              (rest (string-drop left 4)))
                          (if (regexp-matches? blank this)
                            (lp rest (+ i 1))
                            (begin
                              (vector-set! stacks i (cons this (vector-ref stacks i)))
                              (lp rest (+ i 1)))))))))
            (for-each process-line (cj-get-stacks cj))
            (crane-job stacks (cj-get-instructions cj) size)))
        (define (process-instrlines cj)
          (define (process-line line)
            (let* ((tokens (string-tokenize line))
                   (num-token? (lambda (token) (regexp-matches? (regexp '(+ num)) token)))
                   (count/from/to (map string->number
                                       (filter num-token? tokens))))
              (mov (first count/from/to) (second count/from/to) (third count/from/to))))
          (crane-job
            (cj-get-stacks cj)
            (map process-line (reverse (cj-get-instructions cj)))
            (cj-get-stack-count cj)))
      (process-instrlines (process-stacklines (process-lines port))))))

(define (run-job cj)
  (let ((stacks (vector-copy (cj-get-stacks cj))))
    (define (run-instruction instr)
      (let ((moves (iota (mov-get-count instr)))
            (from (mov-get-from instr))
            (to (mov-get-to instr)))
        (for-each (lambda (q)
                    (begin
                      (vector-set! stacks to (cons (car (vector-ref stacks from))
                                                   (vector-ref stacks to)))
                      (vector-set! stacks from (cdr (vector-ref stacks from)))))
                  moves)))
    (for-each run-instruction (cj-get-instructions cj))
    stacks))

(define (get-result stacks)
  (map (lambda (i) (car (vector-ref stacks i))) (iota (- (vector-length stacks) 1) 1)))

(define (run-job-2 cj)
  (let ((stacks (vector-copy (cj-get-stacks cj))))
    (define (run-instruction instr)
      (let ((count (mov-get-count instr))
            (from (mov-get-from instr))
            (to (mov-get-to instr)))
        (let-values (((take keep) (split-at (vector-ref stacks from) count)))
          (vector-set! stacks to (append take (vector-ref stacks to)))
          (vector-set! stacks from keep))))
    (for-each run-instruction (cj-get-instructions cj))
    stacks))
))
