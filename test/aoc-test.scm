;; SPDX-License-Identifier: AGPL-3.0-or-later
;; aoc-test.scm  test AoC solutions against various implementations
;;               of Scheme
;; Copyright © 2022 Specific Machine
(cond-expand
  (gauche (import (scheme base)
                  (scheme file)
                  (scheme write)
                  (day 1) (day 2) (day 3) (day 4) (prefix (day 5) day5-) (prefix (day 6) day6-)
                  (prefix (day 7) day7-) (prefix (day 8) day8-) (prefix (day 9) day9-)
                  (srfi 64))
          (let ((test-name "gauche-test"))
            (include "test/runner.scm")
            (include "test/test-common.scm")))
  (guile (import (scheme base)
                 (scheme file)
                 (scheme write)
                 (ports day1) (ports day2) (ports day3) (ports day4)
                 (prefix (ports day5) day5-) (prefix (ports day6) day6-) (prefix (ports day7) day7)
                 (prefix (ports day8) day8-)
                 (srfi srfi-64))
         (let ((test-name "guile-test"))
           (include "test/test-common.scm")))
  (gambit (import  (scheme base)
                   (scheme file)
                 (scheme write)
                 (ports 1) (ports 2) (ports 3) (ports 4)
                 (prefix (ports 5) day5-) (prefix (ports 6) day6-) (prefix (ports 7) day7-)
                 (prefix (ports 8) day8-) (prefix (ports 9) day9-)
                 (srfi 64))
          (let ((test-name "gambit-test"))
           (include "test-common.scm")))
    

  )

