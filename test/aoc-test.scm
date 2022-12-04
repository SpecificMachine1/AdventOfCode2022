;; SPDX-License-Identifier: AGPL-3.0-or-later
;; aoc-test.scm  test AoC solutions against various implementations
;;               of Scheme
;; Copyright © 2022 Felix Thibault
(import (scheme base)
	(scheme file)
	(day 1)
	(srfi 64))
(cond-expand
  (gauche (let ((test-name "gauche-test"))
	      (include "test/test-common.scm"))))

