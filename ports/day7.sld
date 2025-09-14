;; https://adventofcode.com/2022/day/7
(define-library (ports day7)
  (import
    (scheme base)
    (aoc file)
    (aoc string)
    (srfi srfi-1)
    (scheme cxr))
  (export get-data dir-get-size dir-get-dirs find-sub-dir dirs-with-max-size size-of-dir-to-free-space)
(begin
  (define-record-type <dir>
    (dir name dirs files size)
    dir?
    (name dir-get-name)
    (dirs dir-get-dirs dir-set-dirs!)
    (files dir-get-files dir-set-files!)
    (size dir-get-size dir-set-size!))
  (define-record-type <file>
    (file name size)
    file?
    (name file-get-name)
    (size file-get-size))
  
  (define (add-to-dir dir obj)
    (cond
      ((file? obj) (dir-set-files! dir (cons obj (dir-get-files dir))))
      ((dir? obj) (dir-set-dirs! dir (cons obj (dir-get-dirs dir))))))

  (define (incr-size dirs size)
    (map  (lambda (dir) (dir-set-size! dir (+ size (dir-get-size dir)))) dirs))

  (define (find-sub-dir name dir)
    (find (lambda (d) (string=? (dir-get-name d) name)) (dir-get-dirs dir)))

  (define (get-data filename)
    (let ((line-tokens (get-line-tokens filename)))
      (define (make-records line-tokens)
        "line-token stack -> command-tokens/file/dir stack"
        (let lp ((this (car line-tokens)) (rest (cdr line-tokens)) (acc '()))
          (cond
            ((null? rest) (cons (dir "/" '() '() 0) (cons this acc)))
            ((string=? "$" (car this)) (lp (car rest) (cdr rest) (cons this acc)))
            ((string=? "dir" (car this)) (lp (car rest) (cdr rest) (cons (dir (cadr this) '() '() 0) acc)))
            ((number-string? (car this))
             (lp (car rest) (cdr rest) (cons (file (cadr this) (string->number (car this))) acc)))
            (else (error "unrecognized tokens" this)))))
      (define (build-tree stack)
        "command tokens/file/dir stack -> dir tree"
        (let ((top-level (car stack)))
          (let command-loop ((this (cadr stack)) (rest (cddr stack)) (current-dirs (list top-level)))
            (cond
              ((string=? "cd" (cadr this)) (let ((name (caddr this)))
                                             (cond
                                               ((string=? name "..")
                                                (command-loop (car rest) (cdr rest) (cdr current-dirs)))
                                               ((find-sub-dir name (car current-dirs)) =>
                                                (lambda (d)
                                                  (command-loop (car rest) (cdr rest) (cons d current-dirs))))
                                               ((string=? name (dir-get-name (car current-dirs)))
                                                (command-loop (car rest) (cdr rest) current-dirs))
                                               (else (error "directory not found")))))
              ((string=? "ls" (cadr this))
               (let ls-loop ((stack rest) (size-acc 0))
                 (cond
                   ((null? stack) (incr-size current-dirs size-acc)
                                  top-level)
                   ((pair? (car stack)) (incr-size current-dirs size-acc)
                                        (command-loop (car stack) (cdr stack) current-dirs))
                   ((dir? (car stack)) (add-to-dir (car current-dirs) (car stack))
                                       (ls-loop (cdr stack) size-acc))
                   ((file? (car stack)) (add-to-dir (car current-dirs) (car stack))
                                       (ls-loop (cdr stack) (+ size-acc (file-get-size (car stack)))))
                   (else (error "unrecognized item in stack" (car stack))))))
              (else (error "unknown command" (car this)))))))
      (build-tree (make-records line-tokens))))

  (define (dirs-with-max-size dir max-size)
    (let search-loop ((dirs (list dir)) (results '()))
      (cond
        ((null? dirs) (fold (lambda (d acc) (+ (dir-get-size d) acc)) 0 results))
        (else (search-loop (apply append (map dir-get-dirs dirs))
                           (append (filter (lambda (d) (<= (dir-get-size d) max-size)) dirs) results))))))

  (define (filter-dirs pred top-level)
    (let search-loop ((dirs (list top-level)) (results '()))
      (cond
        ((null? dirs) results)
        (else (search-loop (apply append (map dir-get-dirs dirs))
                           (append (filter pred dirs) results))))))

  (define (size-of-dir-to-free-space total needed top-level)
    (let* ((free (- total (dir-get-size top-level)))
           (need-to-free (- needed free))
           (possibles (filter-dirs (lambda (d) (>= (dir-get-size d) need-to-free)) top-level)))
      (fold
        (lambda (d size) (if (< (dir-get-size d) size) (dir-get-size d) size))
        (dir-get-size (car possibles))
        (cdr possibles))))
))
