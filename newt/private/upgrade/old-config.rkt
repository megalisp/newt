#lang racket/base

;; This is only used to read the deprecated .newtrc -- from which we attempt
;; to create an equivalent newt.rkt for users.

(require racket/require
         (multi-in racket (dict file match runtime-path string))
         "../verbosity.rkt")

(provide maybe-newtrc->newt.rkt
         get-config)

(define-runtime-path template-newt.rkt "template-newt.rkt")

(define (maybe-newtrc->newt.rkt top)
  (when (file-exists? (build-path top ".newtrc"))
    (define newt.rkt (build-path top "newt.rkt"))
    (unless (file-exists? newt.rkt)
      (prn0 "Creating newt.rkt from .newtrc -- see upgrade documentation.")
      (flush-output)
      (parameterize ([current-directory top])
        (with-output-to-file newt.rkt
          #:mode 'text #:exists 'error
          (λ () (dynamic-require template-newt.rkt #f)))
        (add-deprecation-comment-to-.newtrc)))))

(define config #f) ;; (hash/c symbol? any/c)
(define (get-config name default cfg-path) ;; (symbol? any/c path? -> any/c)
  ;; Read all & memoize
  (unless config
    (set! config (read-config cfg-path)))
  (cond [(dict-has-key? config name)
         (define v (dict-ref config name))
         (cond [(string? default) v]
               [(boolean? default) v]
               [(number? default)
                (or (string->number v)
                    (begin
                      (eprintf
                       "Expected number for ~a. Got '~a'. Using default: ~a\n"
                       name v default)
                      default))]
               [else (raise-type-error 'get-config
                                       "string, boolean, or number"
                                       v)])]
        [else default]))

(define (read-config p)
  (cond [(file-exists? p)
         (for/hasheq ([s (file->lines p)])
           (match s
             [(pregexp "^(.*)#?.*$" (list _ s))
              (match s
                [(pregexp "^\\s*(\\S+)\\s*=\\s*(.+)$" (list _ k v))
                 (values (string->symbol k) (maybe-bool v))]
                [else (values #f #f)])]
             [_ (values #f #f)]))]
        [else (make-hasheq)]))

(define (maybe-bool v) ;; (any/c -> (or/c #t #f any/c))
  (match v
    [(or "true" "#t") #t]
    [(or "false" "#f") #f]
    [else v]))

(define (add-deprecation-comment-to-.newtrc)
  (define s (string-join (list (make-string 76 #\#)
                               "#"
                               "# THIS FILE IS NO LONGER USED."
                               "# Use newt.rkt instead."
                               "#"
                               (make-string 76 #\#)
                               (file->string ".newtrc" #:mode 'text))
                         "\n"))
  (display-to-file s ".newtrc"
                   #:mode 'text
                   #:exists 'replace))
