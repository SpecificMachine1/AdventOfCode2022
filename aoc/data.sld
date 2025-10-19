(define-library (aoc data)
  (import (scheme base)
          (srfi 1))
  (export chunk-data sign range-inclusive)
(begin

  (define (chunk-data data chunk-size gap-size)
    (let loop ((left data) (acc '()) (len (length data)))
      (cond
        ((<= len chunk-size) (cons (take left chunk-size) acc))
        (else (loop (drop left (+ chunk-size gap-size))
                    (cons (take left chunk-size) acc)
                    (- len (+ chunk-size gap-size)))))))

  (define (sign n)
    "returns 1 for positive, 0 for 0, and -1 for negative"
    (cond
      ((positive? n) 1)
      ((zero? n) 0)
      (else -1)))

  (define (range-inclusive n m)
    "(range-inclusive n m) -> (n ... m), n < m, integer? (- m n)"
    (iota (- (+ m 1) n) n))

))
