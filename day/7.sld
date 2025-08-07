;; https://adventofcode.com/2022/day/7
(define-library (day 7)
  (import
    (scheme base)
    (scheme file)
    (scheme list))
(begin
  ;; records for commands
  (define-record-type <jump-to-child>
    (jump-to-child dir)
    jump-to-child?
    (dir jtc-get-dir))

  (define-record-type <jump-to-parent>
    (jump-to-parent)
    jump-to-parent?)

  (define-record-type <jump-to-top>
    (jump-to-top)
    jump-to-top?)

  (define-record-type <ls>
    (ls)
    ls?)

  ;; data records
  (define <dir>
    (dir name contents)
    dir?
    (name dir-get-name)
    (contents dir-get-contents dir-set-contents!))
  
  (define (add-to-dir dir)
    (let (())))
))
