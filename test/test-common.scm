;; SPDX-License-Identifier: AGPL-3.0-or-later
;; test-common.scm srfi-64 tests for each day
;; Copyright © 2022 Specific Machine
(test-begin test-name)
(let ((test-data (get-data
		   (open-input-file "../data/day1-example1.dat"))))
  (test-eq "1.1-most-calories" 24000 (most-calories test-data))
  (test-assert "1.2-calories-of-top-three"
	       (let ((top-three (calories-of-top-three test-data)))
		 (and (member 24000 top-three)
		      (member 11000 top-three)
		      (member 10000 top-three)))))
(test-end test-name)
