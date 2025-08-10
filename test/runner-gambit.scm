(import (scheme base)
        (scheme write)
        (srfi 64))
(define (send-text . a)
  (display (apply string-append a))
  (newline))
(define (my-simple-runner)
  (let ((runner (test-runner-null))
        (num-passed 0)
        (num-failed 0))
    (test-runner-on-test-begin! runner
      (lambda (runner)
        (display (test-runner-test-name runner))
        (display ",\t")))
    (test-runner-on-test-end! runner
      (lambda (runner)
        (case (test-result-kind runner)
          ((pass xpass) (set! num-passed (+ num-passed 1))
                        (send-text " pass " ))
          ((fail xfail) (set! num-failed (+ num-failed 1))
                        (send-text " fail "))
          (else #t))))
    (test-runner-on-final! runner
       (lambda (runner)
          (send-text "Passing tests: " 
                      (number->string num-passed)
                      ",:"
                      "\t"
                      " Failing tests: "
                      (number->string num-failed))))
    runner))

(test-runner-factory
 (lambda () (my-simple-runner)))
