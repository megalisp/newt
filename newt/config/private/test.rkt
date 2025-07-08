#lang racket/base

(module+ test
  (require rackunit)

  (module m newt/config/main
    (define init #f)
    (define enhance-body #f)
    (define clean #f))

  (check-not-exn (λ () (eval '(module m newt/config/main
                               (define init #f)
                               (define enhance-body #f)
                               (define clean #f))
                             (make-base-namespace))))

  (check-exn #rx"newt/config: You must define a function named \"init\""
             (λ () (eval '(module m newt/config/main
                           #;(define init #f)
                           (define enhance-body #f)
                           (define clean #f))
                         (make-base-namespace))))

  (check-exn #rx"newt/config: You must define a function named \"enhance-body\""
             (λ () (eval '(module m newt/config/main
                           (define init #f)
                           #;(define enhance-body #f)
                           (define clean #f))
                         (make-base-namespace))))

  (check-exn #rx"newt/config: You must define a function named \"clean\""
             (λ () (eval '(module m newt/config/main
                           (define init #f)
                           (define enhance-body #f)
                           #;(define clean #f))
                         (make-base-namespace)))))
