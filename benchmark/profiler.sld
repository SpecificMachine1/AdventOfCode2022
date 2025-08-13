(define-library (benchmark profiler)
  (import (scheme base)
          (scheme write)
          (scheme time))
  (export time-it start-run run)
(begin
(define-syntax time-it
  (syntax-rules ()
    ((time-it n body ...)
     (let ((start (current-jiffy))
           (MICRO 1000000)
           (MILLI 1000))
       (let lp ((i n))
         (if (zero? i)
           (inexact (* MILLI (/ (- (current-jiffy) start) 
                               (jiffies-per-second)
                               n)))
           (begin
             body ...
             (lp (- i 1)))))))))
(define (start-run)
  (display "name, millisec to run once, average millisec for 100 runs\n"))
(define-syntax run
  (syntax-rules ()
    ((run name body ...)
     (let ((once (time-it 1 body ...))
           (fifty-times (time-it 100 body ...)))
       (display (string-append name "," (number->string once) "," (number->string fifty-times) "\n"))))))
))
