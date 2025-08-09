(define-library (profiler)
  (import (scheme base)
          (scheme write)
          (scheme time))
  (export time-it)
(begin
(define MILLI  1000)
(define MICRO  1000000)
(define NANO   1000000000)  
(define-syntax time-it
  (syntax-rules ()
    ((time-it n body ...)
     (let ((start (current-jiffy)))
       (let lp ((i n))
         (if (zero? i)
           (inexact (* MICRO (/ (- (current-jiffy) start) 
                               (jiffies-per-second)
                               n)))
           (begin
             body ...
             (lp (- i 1)))))))))
))
