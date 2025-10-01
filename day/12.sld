(define-library (day 12)
  (import (scheme base)
          (scheme char)
          (srfi 69)
          (scheme write)
          (only (srfi 1) filter)
          (aoc file)
          (aoc matrix))
  (export get-data find-shortest-path path-get-history)
(begin
  (define-record-type <maze>
    (maze map start end)
    maze?
    (map get-map)
    (start get-start)
    (end get-end))

(define (get-data filename)
  (let ((data (parameterize 
                ((file-cons (lambda (this acc) (cons (string->list this) acc))))
                (file-fold filename)))
        (start #f)
        (end #f))
    (define (char->height char i j)
      (cond
        ((eq? char #\S) (set! start (list i j))
                        0)
        ((eq? char #\E) (set! end (list i j))
                        25)
        (else (- (char->integer char) (char->integer #\a)))))
    (let ((maze-matrix (matrix-map char->height (list->matrix (reverse data)))))
      (maze maze-matrix start end))))

(define-record-type <path>
  (path history tracker)
  path?
  (history path-get-history)
  (tracker path-get-tracker))

(define (make-path) (path '() (make-hash-table)))

(define (extend-path pth pos)
  (let ((table (path-get-tracker pth))) (hash-table-set! table  pos #f)
  (path (cons pos (path-get-history pth)) table)))

(define (unvisited? path pos)
  (hash-table-ref/default (path-get-tracker path) pos #t))

(define (find-shortest-path maze)
  (let* ((start (get-start maze))
        (end (get-end maze))
        (grid (get-map maze)))
    (define (get-possibles path)
      (let-values (((i j) (apply values (car (path-get-history path)))))
        (let ((candidates `((,(+ i 1) ,j) (,i ,(+ j 1)) (,(- i 1) ,j) (,i ,(- j 1)))))
          (filter (lambda (pos)  (and (<= 0 (car pos) (- (matrix-get-m grid) 1))
                                      (<= 0 (cadr pos) (- (matrix-get-n grid) 1))
                                      (<= (- (matrix-get-element grid (car pos) (cadr pos))
                                             (matrix-get-element grid i j))
                                          1)
                                      (unvisited? path pos)))
                  candidates))))
    (let path-loop ((paths (list (extend-path (make-path) start))) (extended-paths '()))
      (cond
        ((null? paths) (if (null? extended-paths)
                         (error "did not find" end)
                         (path-loop extended-paths '())))
        (else (let ((this-path (car paths)))
                (let extension-loop ((possibles (get-possibles this-path)) 
                                    (next-paths '()))
                (cond
                  ((null? possibles) (path-loop (cdr paths) (append extended-paths next-paths)))
                  ((equal? (car possibles) end) (extend-path this-path end))
                  (else (extension-loop (cdr possibles) (cons (extend-path this-path (car possibles)) next-paths)))))))))))

))
