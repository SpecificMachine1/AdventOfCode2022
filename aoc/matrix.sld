(define-library (aoc matrix)
  (import (scheme base))
  (export list->matrix matrix-get-element matrix? matrix-get-m matrix-get-n
          matrix-get-row matrix-get-column matrix-get-rows matrix-get-columns
          matrix-fold)
(begin

  (define-record-type <matrix>
    (matrix m n rows columns)
    matrix?
    (m matrix-get-m)
    (n matrix-get-n)
    (rows matrix-get-rows)
    (columns matrix-get-columns))

  (define (list->matrix list-of-lists)
    (define (transpose-lol lol)
      (apply map (cons list lol)))
    (matrix (length list-of-lists)
            (length (car list-of-lists))
            (list->vector (map list->vector list-of-lists))
            (list->vector (map list->vector (transpose-lol list-of-lists)))))
  
  (define (matrix-get-element matrix i j)
    (vector-ref (vector-ref (matrix-get-rows matrix) i) j))

  (define (matrix-get-row matrix i)
    (vector-ref (matrix-get-rows matrix) i))

  (define (matrix-get-column matrix j)
    (vector-ref (matrix-get-columns matrix) j))

  (define (matrix-fold matrix-cons nil matrix)
    (let ((m (matrix-get-m matrix))
          (n (matrix-get-n matrix)))
      (let i-loop ((i 0) (acc nil))
        (cond
          ((= i m) acc)
          (else (let j-loop ((j 0) (acc acc))
                  (cond
                    ((= j n) (i-loop (+ i 1) acc))
                    (else (j-loop (+ j 1) (matrix-cons i j acc))))))))))
))
