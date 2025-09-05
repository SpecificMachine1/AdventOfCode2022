(define-library (benchmark profiler)
  (import (scheme base)
          (scheme write)
          (scheme time))
  (export time-it start-run run units milli micro nano runs)
(begin
  ;; time parameters
  (define milli 1000)
  (define micro 1000000)
  (define nano  1000000000)

  (define units (make-parameter micro))

  (define (unit-name)
    (case (units)
      ((1)          "seconds")
      ((1000)       "milliseconds")
      ((1000000)    "microseconds")
      ((1000000000) "nanoseconds")
      (else (string-append "1/" (number->string (units)) "ths of a second"))))

  ;; run parameters
  (define runs (make-parameter 100))

  (define-syntax time-it
    (syntax-rules ()
      ((time-it body ...)
       (let ((start (current-jiffy)))
         (let lp ((i (runs)))
           (if (zero? i)
             (inexact (* (units) (/ (- (current-jiffy) start) 
                                    (jiffies-per-second)
                                    (runs))))
             (begin
               body ...
               (lp (- i 1)))))))))
  (define (start-run)
    (display (string-append "name, " (unit-name) " to run once, average " (unit-name) " for " (number->string (runs)) " runs\n")))
  (define-syntax run
    (syntax-rules ()
      ((run name body ...)
       (let ((once (parameterize ((runs 1)) (time-it body ...)))
             (multi (time-it body ...)))
         (display (string-append name "," (number->string once) "," (number->string multi) "\n"))))))
  ))
