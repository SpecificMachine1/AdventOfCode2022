;; SPDX-License-Identifier: AGPL-3.0-or-later
;; test-common.scm srfi-64 tests for each day
;; Copyright © 2022 Specific Machine
(display "test, \t status \n")
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

;;day 5 tests
(let ((test-data (day5-get-data "../data/day5-example1.dat")))
  (test-equal "5.1 mov one at a time" (list "[C]" "[M]" "[Z]") (day5-get-result (day5-run-job test-data)))
  (test-equal "5.2 mov all at once" (list "[M]" "[C]" "[D]") (day5-get-result (day5-run-job-2 test-data))))

;;day 6 tests
(let ((data-1 (day6-get-data "../data/day6-example1.dat"))
     (data-2 (day6-get-data "../data/day6-example2.dat"))
     (data-3 (day6-get-data "../data/day6-example3.dat"))
     (data-4 (day6-get-data "../data/day6-example4.dat"))
     (data-5 (day6-get-data "../data/day6-example5.dat")))
    (test-assert "6.1 find packet start"
                 (and (= (day6-ds-start data-1) 7)
                      (= (day6-ds-start data-2) 5)
                      (= (day6-ds-start data-3) 6)
                      (= (day6-ds-start data-4) 10)
                      (= (day6-ds-start data-5) 11)))
    (test-assert "6.2 find message start"
                 (and (= (day6-get-start-of-message data-1) 19)
                      (= (day6-get-start-of-message data-2) 23)
                      (= (day6-get-start-of-message data-3) 23)
                      (= (day6-get-start-of-message data-4) 29)
                      (= (day6-get-start-of-message data-5) 26))))
(test-end test-name)
