(define-library (day 6)
  (import (scheme base)
          (scheme file)
          (scheme list)
          (scheme charset))
  (export ds-start ds-data get-data get-start-of-message)
(begin
  (define-record-type <datastream>
    (datastream data start)
    datastream?
    (data ds-data)
    (start ds-start))
  (define (get-data filename)
    (call-with-input-file
      filename
      (lambda (port)
        (let ((data (string->list (read-line port))))
          (define (check-window keys)
            (= 4 (char-set-size (list->char-set keys))))
          (datastream data (call/cc
                             (lambda (return)
                               (fold  (lambda (next prev)
                                        (if (check-window (car prev))
                                          (return (cadr prev))
                                          (list (append (cdar prev) (list next)) 
                                                (+ 1 (cadr prev)))))
                                (list (take data 4) 4)
                                (drop data 4)))))))))

  (define (get-start-of-message datastream)
    (let ((data (ds-data datastream)))
          (define (check-window keys)
            (= 14 (char-set-size (list->char-set keys))))
          (call/cc
            (lambda (return)
              (fold  (lambda (next prev)
                       (if (check-window (car prev))
                         (return (cadr prev))
                         (list (append (cdar prev) (list next)) 
                               (+ 1 (cadr prev)))))
                     (list (take data 14) 14)
                     (drop data 14))))))
))
