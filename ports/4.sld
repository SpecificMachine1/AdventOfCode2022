;; https://adventofcode.com/2022/day/4
(define-library (ports 4)
  (export filename->result-4.1 filename->result-4.2)
  (import (scheme base)
          (scheme cxr)
          (scheme read)
          (scheme file)
          (only (srfi 1) fold))
  (begin
    #| First task
    The data file consists of characters in this format:
      A-B,C-D  (one per line)
    which represent ranges of numbers
    the task is to find which pairs have one range fully contained in the other
    |#

    ;; (get-data-4.1 filename)  String -> [List-of [List-of [List-of N]]]
    (define (get-data-4.1 filename)
      ;; (handle-line line) -> [list-of [list-of N]]
      ;; converts data from "A-B,C-D" to ((A B) (C D))
      (define (handle-line line)
        (define (line->sexp-string line)
          (apply string-append (append '("((")
                                       (map (lambda (c)
                                              (cond
                                                ((char=? c #\-) " ")
                                                ((char=? c #\,) ") (")
                                                (else (list->string (list c)))))
                                            (string->list line))
                                       '("))"))))
        (read (open-input-string
                (line->sexp-string line))))
      (call-with-input-file
        filename
        (lambda (port)
          (let lp ((line (read-line port)) (out '()))
            (if (eof-object? line)
              (reverse out)
              (lp (read-line port) (cons (handle-line line) out)))))))
    
    ;;(get-data-4.1 "./data/day4-example1.dat")

    ;;
    (define (fully-contains? ranges)
      (let ((A (caar ranges))
            (B (cadar ranges))
            (C (caadr ranges))
            (D (cadadr ranges)))
        (if (or (and (>= A C) (<= B D))
                (and (>= C A) (<= D B)))
          1
          0)))

    ;; (filename->result-4.1 filename) String -> N
    ;; find the total number of overlapping ranges in the file
    (define (filename->result-4.1 filename)
      (fold + 0 (map fully-contains? (get-data-4.1 filename))))
    
    ;;
    (define (partially-contains? ranges)
      (let ((A (caar ranges))
            (B (cadar ranges))
            (C (caadr ranges))
            (D (cadadr ranges)))
        (if (or (or (<= C A D) (<= C B D))
                (or (<= A C B) (<= A D B)))
          1
          0)))

    ;; (filename->result-4.1 filename) String -> N
    ;; find the total number of overlapping ranges in the file
    (define (filename->result-4.2 filename)
      (fold + 0 (map partially-contains? (get-data-4.1 filename))))
    
    ))
