;;; substitute for combo of (srfi 64) + runner that outputs
;;; test results in csv format)
;;; SPDX-License-Identifier: AGPL-3.0-or-later
(define-library (test simple)
  (import (scheme base)
          (scheme write))
  (export test-begin test-eq test-equal test-assert test-end)
(begin

  (define passed 0)
  (define failed 0)
  (define test-name #f)

  (define (test-begin name) (set! test-name name))

  (define (test-eq name expected expression)
       (cond
         ((eq? expected expression) (set! passed (+ passed 1))
                                    (display (string-append name ", \t" "pass\n"))
                                    (flush-output-port))
         (else (set! failed (+ failed 1))
               (display (string-append name ", \t" "fail\n"))
               (flush-output-port))))

  (define (test-equal name expected expression)
       (cond
         ((equal? expected expression) (set! passed (+ passed 1))
                                       (display (string-append name ", \t" "pass\n"))
                                       (flush-output-port))
         (else (set! failed (+ failed 1))
               (display (string-append name ", \t" "fail\n"))
               (flush-output-port))))

  (define (test-assert name expression)
       (cond
         (expression (set! passed (+ passed 1))
                     (display (string-append name ", \t" "pass\n"))
                     (flush-output-port))
         (else (set! failed (+ failed 1))
               (display (string-append name ", \t" "fail\n"))
               (flush-output-port))))

  (define (test-end name)
    (display (string-append "Passing tests: " (number->string passed) ", \t Failing tests: " (number->string failed)))
    (newline)
    (set! passed 0)
    (set! failed 0)
    (set! test-name #f))

))
