#lang info
(define raco-commands '(("newt" (submod newt/main main) "run Newt" #f)))
(define scribblings '(("newt.scrbl" (multi-page))))
(define clean '("compiled" "doc" "doc/newt"))
