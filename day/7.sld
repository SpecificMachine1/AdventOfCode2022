;; https://adventofcode.com/2022/day/7
(define-library (day 7)
  (import
    (scheme base)
    (scheme file)
    (scheme list)
    (only (srfi 13) string-tokenize))
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
  (define-record-type <dir>
    (dir name contents)
    dir?
    (name dir-get-name)
    (contents dir-get-contents dir-set-contents!))
  (define-record-type <file>
    (file name size)
    file?
    (name file-get-name)
    (size file-get-size))
  
  (define (add-to-dir dir obj)
    (dir-set-contents! (cons obj (dir-get-contents dir))))

  (define (get-data filename)
    (with-input-from-file ;trying this one this time
      filename
      (lambda ()
        (define (get-tokens)
          (let lp ((line (read-line)) (tokens '()))
            (if (eof-object? line)
              (reverse tokens)
              (lp (read-line) (cons (string-tokenize line) tokens)))))
        (define (handle-tokens tokens)
          (match tokens
                 ((("$" c ...) rest ...) (handle-command c rest))
                 ((("dir" name)) (dir name '()))
                 ((size name) (file name (string->number size)))
                 (() '()))))))

))
