(define-library (day 5)
  (import (scheme base)
          (scheme list)
          (scheme file)
          (srfi 130)
          (srfi 115)
          (scheme vector)
          (only (srfi 13) string-tokenize)
          (scheme write))
  (export get-data cj-get-stacks cj-get-instructions cj-get-stack-count)
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
  (mov stack from to)
  mov?
  (stack mov-get-stack)
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
                   (display stacks)
                   (lp (read-line port) stacklines instrlines (+ 1 stacks) 'inst)))
                ((eqv? mode 'inst)
                 (display stack-count)
                 (lp (read-line port) stacklines (cons line instrlines) stack-count mode))
                (else (lp (read-line port) (cons line stacklines) instrlines stack-count mode))))))
      (process-lines port))))
))
