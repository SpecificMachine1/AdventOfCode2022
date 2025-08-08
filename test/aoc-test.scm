;; SPDX-License-Identifier: AGPL-3.0-or-later
;; aoc-test.scm  test AoC solutions against various implementations
;;               of Scheme
;; Copyright © 2022 Specific Machine
(import (scheme base)
	(scheme file)
        (scheme write)
	(day 1) (day 2) (day 3) (day 4) (prefix (day 5) day5-) (prefix (day 6) day6-)
	(srfi 64))
(cond-expand
  (gauche (let ((test-name "gauche-test"))
	      (include "test/test-common.scm")))
  (chibi (let ((test-name "chibi-test"))
           (include "test/test-common.scm"))))

