(define-library (profiler)
  (import (scheme base)
          (scheme write)
          (scheme time))
  (export time-it)
(begin
(define-syntax time-it
  (syntax-rules ()
    ((time-it n body ...)
     (let ((start (current-jiffy))
           (MICRO 1000000))
       (let lp ((i n))
         (if (zero? i)
           (inexact (* MICRO (/ (- (current-jiffy) start) 
                               (jiffies-per-second)
                               n)))
           (begin
             body ...
             (lp (- i 1)))))))))
))
