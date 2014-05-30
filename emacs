;=======================================================================
; package install
;=======================================================================
; packages list
(setq package-list '(evil auto-complete magit helm paredit helm-projectile
                     projectile git-gutter ace-jump-mode rainbow-delimiters
                     cider coffee-mode flycheck jade-mode stylus-mode
                     sws-mode highlight-indentation simple-httpd js2-mode
                     skewer-mode go-mode go-autocomplete haskell-mode ghc
                     exec-path-from-shell 
                     ))

; repositories 
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ;("elpa" . "http://tromey.com/elpa/")
                         ;("gnu" . "http://elpa.gnu.org/packages/")
                         ;("marmalade" . "http://marmalade-repo.org/packages/")
                         ))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
  
;=======================================================================
; emacs settings
;=======================================================================

;-----------------------------------------------------------------------
; mac env paths
;-----------------------------------------------------------------------
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;-----------------------------------------------------------------------
; debug-mode
;-----------------------------------------------------------------------
;(setq debug-on-error t)

;-----------------------------------------------------------------------
; tool-bar-mode 
;-----------------------------------------------------------------------
(tool-bar-mode -1)

;-----------------------------------------------------------------------
; mac command key
;-----------------------------------------------------------------------
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;-----------------------------------------------------------------------
; tabs
;-----------------------------------------------------------------------
;(setq-default indent-tabs-mode nil)
;(setq-default tab-width 2)
;(setq indent-line-function 'insert-tab)

;-----------------------------------------------------------------------
; scroll-bar-mode
;-----------------------------------------------------------------------
(scroll-bar-mode -1)

;-----------------------------------------------------------------------
; electric-pair-mode 
;-----------------------------------------------------------------------
(electric-pair-mode 1)
  
;-----------------------------------------------------------------------
; font
;-----------------------------------------------------------------------
;(set-face-attribute 'default nil :font "DejaVu Sans Mono-14")
(set-face-attribute 'default nil :font "Inconsolata-14")

;-----------------------------------------------------------------------
; backup-directory
;-----------------------------------------------------------------------
(setq backup-directory-alist `(("." . "~/.saves")))

;-----------------------------------------------------------------------
; ring bell sound
;-----------------------------------------------------------------------
(setq ring-bell-function 'ignore)
  
;-----------------------------------------------------------------------
; yes-or-no
;-----------------------------------------------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)

;-----------------------------------------------------------------------
; color-theme
;-----------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/colors/superman-emacs-theme")
(require 'superman-theme)





;=======================================================================
; package settings
;=======================================================================

;-----------------------------------------------------------------------
; evil mode
;-----------------------------------------------------------------------
(evil-mode 1)

;-----------------------------------------------------------------------
; helm mode
;-----------------------------------------------------------------------
(helm-mode t)

;-----------------------------------------------------------------------
; goflycheck mode
;-----------------------------------------------------------------------
(add-to-list 'load-path "~/projects/go/src/github.com/dougm/goflymake")
(require 'go-flycheck)

;-----------------------------------------------------------------------
; auto-complete-mode
;-----------------------------------------------------------------------
(require 'auto-complete-config)
(ac-config-default)

;-----------------------------------------------------------------------
; go-autocomplete
;-----------------------------------------------------------------------
(require 'go-autocomplete)

;-----------------------------------------------------------------------
; paredit-mode
;-----------------------------------------------------------------------
(paredit-mode t)
  
;-----------------------------------------------------------------------
; projectile-global-mode
;-----------------------------------------------------------------------
(projectile-global-mode)

;-----------------------------------------------------------------------
; global-git-gutter
;-----------------------------------------------------------------------
(global-git-gutter-mode t)  

;-----------------------------------------------------------------------
; global-git-gutter
;-----------------------------------------------------------------------
;(global-flycheck-mode t)  

;-----------------------------------------------------------------------
; rainbow-delimiters
;-----------------------------------------------------------------------
(global-rainbow-delimiters-mode)  

;-----------------------------------------------------------------------
; cider / nrepl 
;-----------------------------------------------------------------------
(setq nrepl-hide-special-buffers t)
(setq cider-repl-tab-command 'indent-for-tab-command)
;(setq cider-repl-popup-stacktraces t)
(setq cider-auto-select-error-buffer t)
(setq cider-repl-wrap-history t)



  

;=======================================================================
; keymaps / keybindings
;=======================================================================

;-----------------------------------------------------------------------
; space for save - normal mode
;-----------------------------------------------------------------------
(define-key global-map (kbd "RET") 'newline-and-indent)

;-----------------------------------------------------------------------
; space for save - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd "SPC") 'save-buffer)

;-----------------------------------------------------------------------
; eval emacs file - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",sv")
  (lambda () (interactive) (load-file "~/.emacs")))

;-----------------------------------------------------------------------
; open emacs file - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",ev")
  (lambda () (interactive) (find-file "~/.emacs")))

;-----------------------------------------------------------------------
; open files, recent files, and buffers - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",d") 'helm-for-files)

;-----------------------------------------------------------------------
; search project - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd "M-p")
  (lambda () (interactive) (helm-projectile)))

;-----------------------------------------------------------------------
; comment-or-uncomment - normal mode
;-----------------------------------------------------------------------
(define-key evil-visual-state-map (kbd ",c") 'comment-or-uncomment-region)

;-----------------------------------------------------------------------
; paste - insert mode
;-----------------------------------------------------------------------
(define-key evil-insert-state-map (kbd "M-v") 'evil-paste-after)

;-----------------------------------------------------------------------
; ace-jump - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",q") 'ace-jump-mode)
  
;-----------------------------------------------------------------------
; magit-status - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",m") 'magit-status)

;-----------------------------------------------------------------------
; eval form in repl - normal mode
;-----------------------------------------------------------------------
(define-key evil-normal-state-map (kbd ",er") 'cider-eval-last-sexp-to-repl)


;=======================================================================
; hooks
;=======================================================================

;-----------------------------------------------------------------------
; paredit hook
;-----------------------------------------------------------------------
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'clojure-mode-hook #'enable-paredit-mode)

;-----------------------------------------------------------------------
; haskell hook
;-----------------------------------------------------------------------
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;-----------------------------------------------------------------------
; go hook
;-----------------------------------------------------------------------
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))


;-----------------------------------------------------------------------
; highlight-indentation hook
;-----------------------------------------------------------------------
;(add-hook 'stylus-mode-hook #'highlight-indentation-mode)
;(add-hook 'coffee-mode-hook #'highlight-indentation-mode)
;(add-hook 'jade-mode-hook #'highlight-indentation-mode)

;-----------------------------------------------------------------------
; skewer-mode
;-----------------------------------------------------------------------
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)


;=======================================================================
; auto-mode
;=======================================================================
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)) 

(put 'dired-find-alternate-file 'disabled nil)
