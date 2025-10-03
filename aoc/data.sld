(define-library (aoc data)
  (import (scheme base)
          (srfi 1))
  (export chunk-data)
(begin

  (define (chunk-data data chunk-size gap-size)
    (let loop ((left data) (acc '()) (len (length data)))
      (cond
        ((<= len chunk-size) (cons (take left chunk-size) acc))
        (else (loop (drop left (+ chunk-size gap-size))
                    (cons (take left chunk-size) acc)
                    (- len (+ chunk-size gap-size)))))))

))
