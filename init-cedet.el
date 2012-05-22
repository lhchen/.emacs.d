;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-08-28 21:03:22 Saturday by taoshanwen>

;; cedet1.0pre6 is conflict with which-func
;; after require cedet, which-func cann't work

;; http://emacser.com/install-cedet.htm
;; http://emacser.com/cedet.htm

(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
; (require 'cedet)

(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(semantic-load-enable-guady-code-helpers)
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)

(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)
(define-key semantic-tag-folding-mode-map (kbd "C-c , -") 'semantic-tag-folding-fold-block)
(define-key semantic-tag-folding-mode-map (kbd "C-c , +") 'semantic-tag-folding-show-block)
(define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-all)
(define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-all)


(global-set-key [f12] 'semantic-ia-fast-jump)

(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
					
;; (define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)

(global-ede-mode t)

(require 'sr-speedbar)
(global-set-key (kbd "M-s b o") 'sr-speedbar-open)
(global-set-key (kbd "M-s b k") 'sr-speedbar-close)

;; (eal-define-keys
;;  `speedbar-key-map
;;  `(("j"   speedbar-next)
;;    ("k"   speedbar-prev)
;;    ("o"   other-window)
;;    ("m"   speedbar-toggle-line-expansion)
;;    ("SPC" View-scroll-half-page-forward)
;;    ("u"   View-scroll-half-page-backward)))

(provide 'init-cedet)
