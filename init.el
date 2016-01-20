;; reduce the frequency of garbage collection by making it happen on
;; each 100MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100 mb
;; Allow font-lock-mode to do background parsing
(setq jit-lock-stealth-time 1
      ;; jit-lock-stealth-load 200
      jit-lock-chunk-size 1000
      jit-lock-defer-time 0.05)
;; add personal elisp directory to load-path 
(defun apella:add-path-and-subs (base) 
   (add-to-list 'load-path base) 
   (dolist (f (directory-files base)) 
     (let ((name (concat base "/" f))) 
       (when (and (file-directory-p name) 
                  (not (equal f "..")) 
                  (not (equal f "."))) 
         (add-to-list 'load-path name))))) 
 
 
139 (apella:add-path-and-subs "~/.emacs.d/elisp") 


;;; Install mouse wheel for scrolling
(mwheel-install)

;;; Turn off beeping
(setq visible-bell t)

;;; Turn off any startup messages
(setq inhibit-startup-message 0)
(setq inhibit-scratch-message nil)

;;; Turn off annoying cordump on tooltip "feature" 
(setq x-gtk-use-system-tooltips nil)

;;; Insert spaces instead of tabs
(setq-default indent-tabs-mode nil)

;;; Line numbers and column numbers
(column-number-mode t)
(line-number-mode t)
(global-linum-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("68d36308fc6e7395f7e6355f92c1dd9029c7a672cbecf8048e2933a053cf27e6" "f8fceb5cce25882d0842aac0e75000bc1a06e3c4eac89b61103c6dbfa88e40ad" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "b04425cc726711a6c91e8ebc20cf5a3927160681941e06bc7900a5a5bfe1a77f" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "94ba29363bfb7e06105f68d72b268f85981f7fba2ddef89331660033101eb5e5" default)))
 '(load-home-init-file t t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq c-basic-offset 4) ;; default comments at 4 spaces
(c-set-offset 'innamespace 0) ;; namespaces shouldn't cause indentation
(show-paren-mode t) ;; show matching parenthesis
(c-set-offset 'access-label -2) ;; private, public etc. indent at two spaces

;; load headers files .h as C++ mode not c
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)) ;; treat .h as C++ no C

(set-face-attribute 'default nil
                    :family "Inconsolata"
                    :height 200
                    :weight 'normal)

;; Put emacs backups somewhere else

(push '("." . "~/.emacs-backups") backup-directory-alist)

(setq package-enable-at-startup nil)
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

;;bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)

(setq ring-bell-function 'ignore)

(use-package rtags)
(use-package company-rtags
  :config
  (progn
    (use-package company
      :init
      (progn
        (add-hook 'c-mode-common-hook #'company-mode))
      :config
      (progn
        (add-to-list 'company-backends 'company-rtags)
        (define-key company-mode-map (kbd "M-/") 'company-complete)
    (defun use-rtags (&optional useFileManager)
  (and (rtags-executable-find "rc")
       (cond ((not (gtags-get-rootpath)) t)
             ((and (not (eq major-mode 'c++-mode))
                   (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
             (useFileManager (rtags-has-filemanager))
             (t (rtags-is-indexed)))))

(defun tags-find-symbol-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-symbol-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-tag)))
(defun tags-find-references-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-references-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-rtag)))
(defun tags-find-symbol ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-symbol 'gtags-find-tag-dwim)))
(defun tags-find-references ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-references 'ggtags-find-tag)))
(defun tags-find-file ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-find-file 'gtags-find-file)))
(defun tags-imenu ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-imenu 'idomenu)))

(define-key c-mode-base-map (kbd "M-.") (function tags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "M-,") (function tags-find-references-at-point))
;; (define-key c-mode-base-map (kbd "M-;") (function tags-find-file))
(define-key c-mode-base-map (kbd "C-.") (function tags-find-symbol))
(define-key c-mode-base-map (kbd "C-,") (function tags-find-references))
(define-key c-mode-base-map (kbd "C-<") (function rtags-find-virtuals-at-point))
(define-key c-mode-base-map (kbd "M-i") (function tags-imenu))))))

(defalias 'yes-or-no-p 'y-or-n-p)
(load-theme 'misterioso)

(use-package magit
  :defer 2
  :config
  (progn
    (setq magit-log-arguments
          '("--graph" "--color"  "-n128"))
    (global-set-key (kbd "C-c g") 'magit-status)))

(global-auto-revert-mode t)



;; BDE style 
(require 'init-bde-style)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(use-package undo-tree
  :defer 5
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1))

(use-package rtags)
(use-package company-rtags
  :config
  (progn
    (use-package company
      :init
      (progn
        (add-hook 'c-mode-common-hook #'company-mode))
      :config
      (progn
        (add-to-list 'company-backends 'company-rtags)
        (define-key company-mode-map (kbd "M-/") 'company-complete)
    (defun use-rtags (&optional useFileManager)
  (and (rtags-executable-find "rc")
       (cond ((not (gtags-get-rootpath)) t)
             ((and (not (eq major-mode 'c++-mode))
                   (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
             (useFileManager (rtags-has-filemanager))
             (t (rtags-is-indexed)))))))))
(use-package company-c-headers
  :config
  (progn
    (add-to-list 'company-c-headers-path-system "/bb/build/Linux-x86_64-64/release/robolibs/weekly/lib/dpkgroot/opt/bb/include")
    (add-to-list 'company-backends 'company-c-headers)
    (dolist (elt '(company-bbdb company-css company-semantic company-clang company-xcode company-cmake))
      (setq company-backends (remove elt company-backends)))))
    
(use-package smart-mode-line
  :config
  (progn
    (setq sml/theme 'respectful)
    (sml/setup)
    (sml/toggle-shorten-modes 1)
    (sml/toggle-shorten-directory 1)
    ;;shorten directory to keys/alias specified: 
    ;;(add-to-list 'sml/replacer-regexp-list '("~/mbig/src/groups" ":GROUPS:") t)
    (use-package powerline)
    (use-package smart-mode-line-powerline-theme
      :config
      (progn
        (load-theme 'smart-mode-line-powerline)
        ;; Make sure this call occurs after smart-mode-line-powerline-theme
        (use-package zenburn-theme
          ;;jbeans-theme
          :demand
          :config
          (load-theme 'zenburn))))))
