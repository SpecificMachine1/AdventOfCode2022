;; SPDX-License-Identifier: AGPL-3.0-or-later
;; aoc-test.scm  test AoC solutions against various implementations
;;               of Scheme
;; Copyright © 2022 Specific Machine
(cond-expand
  (gauche (import (scheme base)
                  (scheme file)
                  (scheme write)
                  (day 1) (day 2) (day 3) (day 4) (prefix (day 5) day5-) (prefix (day 6) day6-)
                  (srfi 64))
          (let ((test-name "gauche-test"))
            (include "test/runner.scm")
            (include "test/test-common.scm")))
  (guile (import (scheme base)
                 (scheme file)
                 (scheme write)
                 (guilesrc day1) (guilesrc day2) (guilesrc day3) (guilesrc day4)
                 (prefix (guilesrc day5) day5-) (prefix (guilesrc day6) day6-)
                 (srfi srfi-64))
         (let ((test-name "guile-test"))
           (include "test/test-common.scm")))
  (gambit (import  (scheme base)
                   (scheme file)
                 (scheme write)
                 (guilesrc 1) (guilesrc 2) (guilesrc 3) (guilesrc 4)
                 (prefix (guilesrc 5) day5-) (prefix (guilesrc 6) day6-)
                 (srfi 64))
          (let ((test-name "gambit-test"))
           (include "test-common.scm")))
    

  )

