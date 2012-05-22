;;------------------------------------------------------------------------------
;; Find and load the correct package.el
;;------------------------------------------------------------------------------

;; When switching between Emacs 23 and 24, we always use the bundled package.el in Emacs 24
(let ((package-el-site-lisp-dir (expand-file-name "~/.emacs.d/site-lisp/package")))
  (when (and (file-directory-p package-el-site-lisp-dir)
             (> emacs-major-version 23))
    (message "Removing local package.el from load-path to avoid shadowing bundled version")
    (setq load-path (remove package-el-site-lisp-dir load-path))))

(require 'package)


;;------------------------------------------------------------------------------
;; Patch up annoying package.el quirks
;;------------------------------------------------------------------------------

(defadvice package-generate-autoloads (after close-autoloads (name pkg-dir) activate)
  "Stop package.el from leaving open autoload files lying around."
  (let ((path (expand-file-name (concat name "-autoloads.el") pkg-dir)))
    (with-current-buffer (find-file-existing path)
      (kill-buffer nil))))


;;------------------------------------------------------------------------------
;; Add support to package.el for pre-filtering available packages
;;------------------------------------------------------------------------------

(defvar package-filter-function nil
  "Optional predicate function used to internally filter packages used by package.el.

The function is called with the arguments PACKAGE VERSION ARCHIVE, where
PACKAGE is a symbol, VERSION is a vector as produced by `version-to-list', and
ARCHIVE is the string name of the package archive.")

(defadvice package--add-to-archive-contents
  (around filter-packages (package archive) activate)
  "Add filtering of available packages using `package-filter-function', if non-nil."
  (when (or (null package-filter-function)
            (funcall package-filter-function
                     (car package)
                     (package-desc-vers (cdr package))
                     archive))
    ad-do-it))


;;------------------------------------------------------------------------------
;; On-demand installation of packages
;;------------------------------------------------------------------------------

(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


;;------------------------------------------------------------------------------
;; Standard package repositories
;;------------------------------------------------------------------------------

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))


;;------------------------------------------------------------------------------
;; Also use Melpa for some packages built straight from VC
;;------------------------------------------------------------------------------

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Don't take Melpa versions of certain packages
(setq package-filter-function
      (lambda (package version archive)
        (or (not (string-equal archive "melpa"))
            (not (memq package
                       '(jump rinari slime ; ruby-compilation 
                              color-theme-sanityinc-solarized
                              color-theme-sanityinc-tomorrow
                              ; elisp-slime-nav
                              findr))))))


(defadvice package-download-transaction
  (around disable-keepalives (&optional args) activate)
  "Disable HTTP keep-alives to work around network issues with Melpa host."
  (require 'url-http)
  (let ((url-http-attempt-keepalives nil))
    ad-do-it))


;;------------------------------------------------------------------------------
;; Fire up package.el and ensure the following packages are installed.
;;------------------------------------------------------------------------------

(package-initialize)

(require-package 'ido-ubiquitous)
(when (< emacs-major-version 24)
  (require-package 'color-theme))
(require-package 'fringe-helper)
(require-package 'popup)
(require-package 'gnuplot)
(require-package 'haskell-mode)
(require-package 'tuareg)
(require-package 'magit)
(require-package 'git-blame)
(require-package 'flymake-cursor)
(require-package 'csv-mode)
(require-package 'csv-nav)
(require-package 'json)
(require-package 'js3-mode)
(require-package 'js2-mode)
(require-package 'lua-mode)
(require-package 'project-local-variables)
(require-package 'yari)
(require-package 'rvm)
(require-package 'yaml-mode)
(require-package 'paredit)
(require-package 'eldoc-eval)
(require-package 'yasnippet)
(require-package 'gist)
(require-package 'haml-mode)
(require-package 'sass-mode)
(require-package 'elein)
(require-package 'markdown-mode)
(require-package 'smex)
(require-package 'dired+)
(require-package 'rainbow-mode)
(require-package 'maxframe)
(when (< emacs-major-version 24)
  (require-package 'org))
(require-package 'org-fstree)
(require-package 'htmlize)
(require-package 'diminish)
(require-package 'autopair)
(require-package 'js-comint)
(require-package 'php-mode)
(require-package 'scratch)
(require-package 'mic-paren)
(require-package 'rainbow-delimiters)
(require-package 'todochiku)
(require-package 'marmalade)
(require-package 'textile-mode)
(require-package 'darcsum)
(require-package 'pretty-mode)

;; ruby 
;; (require-package 'ruby-mode)
;; (require-package 'inf-ruby)
;; (require-package 'flymake-ruby)
;; (require-package 'rinari)
;; (require-package 'ruby-compilation)

;; elisp
;; (require-package 'slime)
;; (require-package 'slime-fuzzy)
;; (require-package 'slime-repl)
;; (require-package 'durendal)
;; (require-package 'clojure-mode)
;; (require-package 'clojure-test-mode)
;; (require-package 'clojurescript-mode)


;; I maintain this chunk:
(require-package 'ac-slime)
(require-package 'coffee-mode)
(require-package 'color-theme-sanityinc-solarized)
(require-package 'color-theme-sanityinc-tomorrow)
(require-package 'crontab-mode)
(require-package 'dsvn)
(require-package 'elisp-slime-nav)
(require-package 'flymake-coffee)
(require-package 'flymake-css)
(require-package 'flymake-haml)
(require-package 'flymake-jslint)
(require-package 'flymake-php)
(require-package 'flymake-sass)
(require-package 'flymake-shell)
(require-package 'hippie-expand-slime)
(require-package 'hl-sexp)
(require-package 'ibuffer-vc)
(require-package 'iy-go-to-char)
(require-package 'less-css-mode)
(require-package 'mmm-mode)
(require-package 'move-text)
(require-package 'mwe-log-commands)
(require-package 'pointback)
(require-package 'regex-tool)
(require-package 'session)
(require-package 'tidy)
(require-package 'vc-darcs)
(require-package 'whole-line-or-region)
(require-package 'yasnippet)

(provide 'init-elpa)
