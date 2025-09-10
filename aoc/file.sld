(define-library (aoc file)
  (cond-expand
    (guile (import (scheme base)
                   (scheme file)
                   (srfi srfi-13)))
    (else (import (scheme base)
                  (scheme file)
                  (srfi 13))))
  (export get-line-strings file-read file-nil file-cons file-fold get-line-tokens)
(begin

;; these functions return lines still reversed
(define (get-line-strings filename)
  (call-with-input-file
    filename
    (lambda (port)
      (let lp ((line (read-line port)) (acc '()))
        (if (eof-object? line)
          acc
          (lp (read-line port) (cons line acc)))))))

;; have been playing with parameters lately, not sure if this is
;; a good idea
(define file-read (make-parameter read-line))
(define file-nil (make-parameter '()))
(define file-cons (make-parameter cons))
(define (file-fold filename)
  (call-with-input-file
    filename
    (lambda (port)
      (let ((fr (file-read))
            (fc (file-cons)))
        (let lp ((this (fr port)) (acc (file-nil)))
          (if (eof-object? this)
            acc
            (lp (fr port) (fc this acc))))))))

(define (get-line-tokens filename)
  (parameterize
    ((file-cons (lambda (this acc) (cons (string-tokenize this) acc))))
    (file-fold filename)))

))
