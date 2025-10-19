(define-library (aoc matrix)
  (import (scheme base))
  (export list->matrix matrix-get-element matrix? matrix-get-m matrix-get-n matrix-set-element!
          matrix-get-row matrix-get-column matrix-get-rows matrix-get-columns
          matrix-fold make-list-of-lists matrix-map vector-transpose keep-for-submatrix)
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

  (define (make-list-of-lists m n value)
    (make-list m (make-list n value)))
  
  (define (matrix-get-element matrix i j)
    (vector-ref (vector-ref (matrix-get-rows matrix) i) j))

  (define (matrix-set-element! matrix i j obj)
    (vector-set! (vector-ref (matrix-get-rows matrix) i) j obj)
    (vector-set! (vector-ref (matrix-get-columns matrix) j) i obj))

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

  (define (build-m-by-n m n)
    (let ((outer (make-vector m)))
      (vector-map (lambda (i) (make-vector n)) outer)))

  (define (matrix-map f mat)
    (let* ((m (matrix-get-m mat))
           (n (matrix-get-n mat))
           (new (matrix m n (build-m-by-n m n) (build-m-by-n n m))))
      (let row-loop ((i 0))
        (cond
          ((= i m) new)
          (else (let col-loop ((j 0))
                  (cond ((= j n) (row-loop (+ i 1)))
                        (else (matrix-set-element! new i j (f (matrix-get-element mat i j) i j))
                              (col-loop (+ j 1))))))))))

  (define (vector-transpose vector-of-vectors)
    (apply vector-map (cons vector (vector->list vector-of-vectors))))
  
  ;; At least for the current problem, it easier to define a submatrix by what I am keeping
  ;; so that is how I am writing this procedure, but the more usual way is to define it
  ;; by what is dropped
  (define (keep-for-submatrix in-matrix rows columns)
    (let* ((row-size (length rows))
           (row-vector (make-vector row-size)))
      (let row-loop ((i 0) (rows-left rows))
        (cond
          ((null? rows-left) (let* ((col-size (length columns))
                                    (out-cols (make-vector col-size))
                                    (new-cols (vector-transpose row-vector)))
                               (let col-loop ((i 0) (cols-left columns))
                                 (cond
                                   ((null? cols-left) (matrix row-size col-size (vector-transpose out-cols) out-cols))
                                   (else (vector-set! out-cols i (vector-ref new-cols (car cols-left)))
                                         (col-loop (+ i 1) (cdr cols-left)))))))
          (else (vector-set! row-vector i (matrix-get-row in-matrix (car rows-left)))
                (row-loop (+ i 1) (cdr rows-left)))))))

))
