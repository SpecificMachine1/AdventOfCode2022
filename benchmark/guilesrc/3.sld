;; SPDX-License-Identifier: AGPL-3.0-or-later
;; day/3.sld solutions for day three
;; Copyright © 2022 Specific Machine
;; https://adventofcode.com/2022/day/3
(define-library (guilesrc 3)
  (export get-data-3 Compart Rucksack make-char-table
          item->priority make-rucksack overlap-priorities filename->result-3.1
          filename->result-3.2)
  (import (scheme base)
    (scheme file)
    (scheme char)
    (srfi 69)
    (only (srfi 1) fold take drop split-at))

  (begin
    #|
    A compartment contains:
      a vector with all the characters in a compartment
      a hash-table that represents each compartment, with the character for the
      key, and 1-26 for #\a - #\z and 27-52 for #\A - #\Z
    |#
    (define-record-type Compart
      (compart vec table)
      compart?
      (vec get-vec)
      (table get-table))

    #|
    A rucksack contains a left and a right compartment
    |#
    (define-record-type Rucksack
      (rucksack left-compart right-compart)
      rucksack?
      (left-compart get-left-compart)
      (right-compart get-right-compart))

    ;;get-data-3 string -> [List-of [Vector-of Characters]]
    ;;this function reads data from the file that represents each rucksack
    ;;into vectors of characters
    (define (get-data-3 filename)
      (call-with-input-file
        filename
        (lambda (port)
          (let lp ((line (read-line port))
                   (out '()))
            (if (eof-object? line)
              out
              (lp (read-line port) (cons (string->vector line) out)))))))

    ;;(get-data-3 "./data/day3-example1.dat")

    (define (make-char-table) (make-hash-table char=? ))

    ;;char -> integer
    ;;convert the item to it's priority 1-26 for a-z and 27-52 for A-Z
    (define (item->priority item)
      (cond
        ((char-lower-case? item) (- (char->integer item) 96))
        ((char-upper-case? item) (- (char->integer item) 38))
        (else (error "item not in a-zA-Z" item))))

    ;;make-rucksack [Vector-of characters]-> rucksack
    (define (make-rucksack charvec)
      (let* ((size (vector-length charvec))
             (half-size (/ size 2))
             (left-table (make-char-table))
             (right-table (make-char-table)))
        (let lp ((n 0))
          (if (= n half-size)
            (rucksack (compart (vector-copy charvec 0 (- half-size 1)) left-table)
                      (compart (vector-copy charvec half-size (- size 1)) right-table))
            (let ((left-item (vector-ref charvec n))
                  (right-item (vector-ref charvec (+ n half-size)))) 
               (hash-table-set! left-table left-item (item->priority left-item))
               (hash-table-set! right-table right-item (item->priority right-item))
               (lp (+ n 1)))))))

    ;;overlap-priorities rucksack->integer
    ;;find the priorities of the items which occur in both compartments of a
    ;;rucksak
    (define (overlap-priorities sack)
      (let* ((left-table (get-table (get-left-compart sack)))
             (right-table (get-table (get-right-compart sack))))
        (let lp ((keys (hash-table-keys left-table)))
          (if (hash-table-exists? right-table (car keys))
            (hash-table-ref right-table (car keys))
            (lp (cdr keys))))))

    ;;filename->result-3.1 string->integer
    ;;open the file with filename, find the matching items in the rucksacks,
    ;;and use their priorities to calculate the result
    (define (filename->result-3.1 filename)
      (fold + 0 (map overlap-priorities (map make-rucksack (get-data-3 filename)))))
    
    ;;(filename->result-3.1  "./data/day3-example1.dat")

    ;;(filename->result-3.1  "./data/day3-input.dat")

    (define (filename->result-3.2 filename)
      (fold + 0 (map overlap-priorities-2 (group-in (map make-rucksack (get-data-3 filename)) 3))))

    ;;group-in l n -> [List-of [List length n]]
    (define (group-in l n)
      (let-values (((head tail) (split-at l n)))
        (let lp ((head head)
                 (tail tail)
                 (out '()))
          (if (null? tail)
            (reverse (cons head out))
            (lp (take tail n) (drop tail n) (cons head out))))))

    ;;overlap-priorities [list-of rucksacks] -> integer
    (define (overlap-priorities-2 sacks)
      (let* ((first (car sacks))
             (keys (append (hash-table-keys (get-table (get-left-compart first)))
                           (hash-table-keys (get-table (get-right-compart first)))))
             (rest (cdr sacks)))
        (define (rucksack-contains? sack key)
          (or (hash-table-exists? 
                (get-table (get-left-compart sack))
                key)
              (hash-table-exists?
                (get-table (get-right-compart sack))
                key)))
        (define (rucksack-ref sack key)
          (or (hash-table-ref (get-table (get-left-compart sack)) key (lambda () #f))
              (hash-table-ref (get-table (get-right-compart sack)) key (lambda () #f))))
        (let lp ((this-sack (car rest))
                 (this-rest (cdr rest))
                 (this-key (car keys))
                 (rest-keys (cdr keys)))
          (cond
            ((null? this-rest) (if (rucksack-contains? this-sack this-key)
                                 (rucksack-ref this-sack this-key)
                                 (lp (car rest) (cdr rest) (car rest-keys) (cdr rest-keys))))
            ((rucksack-contains? this-sack this-key) (lp (car this-rest)
                                                         (cdr this-rest)
                                                         this-key
                                                         rest-keys))
            (else (lp (car rest) (cdr rest) (car rest-keys) (cdr rest-keys)))))))

    ;;(map make-rucksack (get-data-3 "./data/day3-example1.dat"))

    ))
