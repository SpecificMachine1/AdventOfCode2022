(define-library (day 13)
  (import (scheme base)
          (scheme read)
          (srfi 1)
          (aoc file)
          (aoc data)
          (aoc string))
  (export get-data packet-compare indices-of-in-order-packets ordered-packets get-decoder-key)
(begin

  (define-record-type <packet-pair>
    (packet-pair left right left-nums right-nums index)
    packet-pair?
    (left get-left)
    (right get-right)
    (left-nums get-left-nums)
    (right-nums get-right-nums)
    (index get-index set-index!))

  (define (get-data filename)
    (let ((chunks (chunk-data (get-line-strings filename) 2 1)))
      (define (handle-chunk chunk)
        (packet-pair (line->value (second chunk))
                     (line->value (first chunk))
                     (line->nums (second chunk))
                     (line->nums (first chunk))
                     #f))
      (define (line->value line)
        (call-with-port (open-input-string (commas->spaces line)) read))
      (define (line->nums line)
        (call-with-port (open-input-string (parenthesize (delim->space line '(#\[ #\] #\,)))) read))
      (let ((packets (map handle-chunk chunks))
            (i 1))
        (for-each (lambda (packet) (set-index! packet i) (set! i (+ i 1))) packets)
        packets)))
;; using make-parameter for quick-and-dirty refactor again
(define pc-get-left (make-parameter get-left))
(define pc-get-right (make-parameter get-right))
  (define (packet-compare packet)
    (let compare-loop ((left ((pc-get-left) packet))
                       (right ((pc-get-right) packet)))
      (cond
        ((and (null? left) (null? right) 0))
        ((null? left) -1)
        ((null? right) 1)
        ((or (number? left) (number? right))
         (cond
           ((and (number? left) (number? right)) (cond
                                                   ((< left right) -1)
                                                   ((= left right) 0)
                                                   (else 1)))
           ((number? left) (compare-loop (list left) right))
           (else (compare-loop left (list right)))))
        (else (let ((cmp (compare-loop (car left) (car right))))
                (if (zero? cmp) (compare-loop (cdr left) (cdr right)) cmp))))))

  (define (indices-of-in-order-packets packets)
    (map get-index (filter (lambda (p) (= (packet-compare p) -1)) packets)))

  (define (packet-sort packet-values)
    (parameterize ((pc-get-left car) (pc-get-right cadr))
      (cond
        ((or (null? packet-values) (null? (cdr packet-values))) packet-values)
        ((null? (cddr packet-values)) (if (= (packet-compare packet-values) -1)
                                        packet-values
                                        (list (cadr packet-values) (car packet-values))))
        (else
          (let* ((pivot (car packet-values)))
            (let-values
              (((smaller bigger)
                (partition (lambda (p) (= (packet-compare (list p pivot)) -1)) (cdr packet-values))))
            (append (packet-sort smaller) (list pivot) (packet-sort bigger))))))))

  (define (packet-pairs->packets packet-pairs)
    (fold (lambda (pp acc) (cons (get-left pp) (cons (get-right pp) acc))) '() packet-pairs))

  (define (ordered-packets packet-pairs)
    (let* ((pairs (cons (packet-pair '((2)) '((6)) 2 6 0) packet-pairs))
           (sorted-packets (packet-sort (packet-pairs->packets pairs))))
      (list->vector sorted-packets)))

  (define (get-decoder-key packet-pairs)
    (let* ((sorted-packets (ordered-packets packet-pairs))
           (size (vector-length sorted-packets)))
      (let search ((i 0) (two-index #f))
        (cond
          ((= i size) (error "not found"))
          ((equal? (vector-ref sorted-packets i) '((6))) (* (+ i 1) (+ two-index 1)))
          ((equal? (vector-ref sorted-packets i) '((2))) (search (+ i 1) i))
          (else (search (+ i 1) two-index))))))

))
