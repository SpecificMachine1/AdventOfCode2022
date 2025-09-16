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
;;day 7 tests
(let* ((data (day7-get-data "../data/day7-example1.dat"))
      (result (day7-dirs-with-max-size data 100000)))
  (test-assert "7.1a check directory size"
               (and (= 584 (day7-dir-get-size (day7-find-sub-dir "e" (day7-find-sub-dir "a" data))))
                    (= 94853 (day7-dir-get-size (day7-find-sub-dir "a" data)))
                    (= 24933642 (day7-dir-get-size (day7-find-sub-dir "d" data)))
                    (= 48381165 (day7-dir-get-size data))))
  (test-equal "7.1b total of directories lte than 100000"  95437 result)
  (test-equal "7.2 space to free" 24933642 (day7-size-of-dir-to-free-space 70000000 30000000 data)))
;;day 8 tests
(let ((data (day8-get-data "../data/day8-example1.dat")))
  (test-equal "8.1 visible trees" (length (day8-visible-trees data)) 21)
  (test-equal "8.2 scenic score" (day8-max-scenic-score data) 8))
(test-end test-name)

#;(let* ((data (day7-get-data "../data/day7-input.dat"))
      (result (day7-dirs-with-max-size data 100000))
      (result2 (day7-size-of-dir-to-free-space 70000000 30000000 data)))
  (display result) (newline) (display result2) (newline))

#;(let ((data (day8-get-data "../data/day8-input.dat")))
  (display (length (day8-visible-trees data)))
  (newline)
  (display (day8-max-scenic-score data))
  (newline))
