#lang racket/base

(require (for-syntax racket/base
                     racket/function
                     racket/syntax))

(begin-for-syntax
  (define provide-syms '(init
                         enhance-body
                         clean))
  (provide provide-syms))

(define-syntax (define-the-things stx)
  (with-syntax ([(id ...) (map (curry format-id stx "~a") provide-syms)]
                [load     (format-id stx "load")])
    #'(begin
        (define id
          (λ _ (error 'id "not yet dynamic-required from newt.rkt"))) ...
        (provide id ...)

        (define (load top)
          (define newt.rkt (build-path top "newt.rkt"))
          (let ([fn (with-handlers ([exn:fail:filesystem? cannot-find-newt.rkt])
                      (dynamic-require newt.rkt 'id))])
            (when fn (set! id fn))) ...)
        (provide load))))

(define-the-things)

(define (cannot-find-newt.rkt . _)
  (eprintf "Cannot open newt.rkt.\nMaybe you need to `raco newt --init` ?\n")
  (exit 1))

(module+ test
  (require rackunit
           racket/runtime-path)
  (test-case "before loading example/newt.rkt"
    (check-exn #rx"init: not yet dynamic-required from newt.rkt"
               (λ () (init)))
    (check-exn #rx"enhance-body: not yet dynamic-required from newt.rkt"
               (λ () (enhance-body '((p () "hi")))))
    (check-exn #rx"clean: not yet dynamic-required from newt.rkt"
               (λ () (clean))))
  (define-runtime-path example "../../../example/")
  (test-case "after loading example/newt.rkt"
    (load example)
    (check-not-exn (λ () (init)))
    (check-not-exn (λ () (enhance-body '((p () "hi")))))
    (check-not-exn (λ () (clean)))))
