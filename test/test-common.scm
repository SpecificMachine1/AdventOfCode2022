;; SPDX-License-Identifier: AGPL-3.0-or-later
;; test-common.scm srfi-64 tests for each day
;; Copyright © 2022 Specific Machine
(test-begin test-name)

;;day 1 tests
(let ((test-data (get-data
		   (open-input-file "../data/day1-example1.dat"))))
  (test-eq "1.1-most-calories" 24000 (most-calories test-data))
  (test-assert "1.2-calories-of-top-three"
	       (let ((top-three (calories-of-top-three test-data)))
		 (and (member 24000 top-three)
		      (member 11000 top-three)
		      (member 10000 top-three)))))

;; day 2 tests
(let ((test-data "../data/day2-example1.dat"))
  (test-eq "2.1-first-method-score" 15 (score-games-2 (get-data-2 test-data)))
  (test-eq "2.2-second-method-score" 12 (score-games-2.1 (get-data-2 test-data))))

;;day 3 tests
(let ((test-data "../data/day3-example1.dat"))
  (test-eq "3.1-first-priority-sum" 157 (filename->result-3.1 test-data))
  (test-eq "3.2-first-priority-sum" 70 (filename->result-3.2 test-data)))

;; day 4 tests
(let ((test-data "../data/day4-example1.dat"))
  (test-eq "4.1-overlapping ranges" 2 (filename->result-4.1 test-data))
  (test-eq "4.2-overlapping ranges" 4 (filename->result-4.2 test-data)))
(test-end test-name)
