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
;;day 9 tests
(let ((data (day9-get-data "../data/day9-example1.dat"))
      (data2 (day9-get-data "../data/day9-example2.dat")))
  (test-equal "9.1 locations visited" (day9-positions-visited (day9-run-motions data)) 13)
  (test-equal "9.2a multi locations; first example" (day9-positions-visited (day9-run-motions* data 10)) 1)
  (test-equal "9.2b multi locations; second example" (day9-positions-visited (day9-run-motions* data2 10)) 36))
;; day 10 tests
(let ((data (day10-get-data "../data/day10-example1.dat")))
  (test-equal "10.1 signal strength at 20/60/100/140/180/220" (day10-run-program-check data) 13140)
  (test-equal "10.2 display on crt" 
              (day10-run-program-on-crt data) (reverse (day10-get-line-strings "../data/day10-crt-output.dat")))) 
;day 11 tests
(let* ((monkeys1 (day11-get-data "../data/day11-example1.dat"))
       (monkeys2 (day11-get-data "../data/day11-example1.dat"))
       (m1-0 (vector-ref monkeys1 0))
       (m1-1 (vector-ref monkeys1 1))
       (m1-2 (vector-ref monkeys1 2))
       (m1-3 (vector-ref monkeys1 3))
       (part-1-factor 3)
       (part-2-factor 1))
  (begin
    (day11-one-round monkeys1 part-1-factor)
    (test-equal "11.1a monkey 0 items after 1 round" (list 20 23 27 26) (day11-monkey-get-items m1-0))
    (test-equal "11.1b monkey 1 items after 1 round" (list 2080 25 167 207 401 1046) (day11-monkey-get-items m1-1))
    (test-equal "11.1c monkey 2 items after 1 round" 0 (length (day11-monkey-get-items m1-2)))
    (test-equal "11.1d monkey 3 items after 1 round0" 0 (length (day11-monkey-get-items m1-3)))
    (day11-n-rounds monkeys1 19 part-1-factor)
    (test-equal "11.1e monkey-business after 20 rounds" 10605 (day11-monkey-business monkeys1)))
  (test-equal "11.2 monkey-business after 10k rounds"
              2713310158
              (day11-monkey-business (day11-n-rounds-2 monkeys2 10000))))
(test-end test-name)

;;;        Generate Output       ;;;

#;(let ((data-1 (day11-get-data "../data/day11-input.dat"))
      (data-2 (day11-get-data "../data/day11-input.dat")))
  (newline) (display (vector-length data-1)) (newline)
  (newline) (display (day11-monkey-business (day11-n-rounds data-1 20 3))) (newline)
  (display (day11-monkey-business (day11-n-rounds-2 data-2 10000))) (newline))
#;(let ((data (day10-get-data "../data/day10-input.dat")))
  (display (day10-run-program-check data))
  (newline)
  (map (lambda (s) (display s) (newline)) (day10-run-program-on-crt data)))

#;(let ((data (day9-get-data "../data/day9-input.dat")))
  (display (day9-positions-visited (day9-run-motions data)))
  (newline)
  (display (day9-positions-visited (day9-run-motions* data 10)))
  (newline))
#;(let* ((data (day7-get-data "../data/day7-input.dat"))
      (result (day7-dirs-with-max-size data 100000))
      (result2 (day7-size-of-dir-to-free-space 70000000 30000000 data)))
  (display result) (newline) (display result2) (newline))

#;(let ((data (day8-get-data "../data/day8-input.dat")))
  (display (length (day8-visible-trees data)))
  (newline)
  (display (day8-max-scenic-score data))
  (newline))
