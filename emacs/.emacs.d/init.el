(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq inhibit-startup-message t) 

(add-to-list 'default-frame-alist '(font . "Lucida Console-9"))

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package diminish
  :ensure t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  :config
  (evil-escape-mode 1))

(use-package hc-zenburn-theme
  :ensure t
  :config
  (load-theme 'hc-zenburn t))

(custom-theme-set-faces
 'hc-zenburn
 '(line-number-current-line ((t (:foreground "#A0EDF0"))))
)

(use-package all-the-icons :ensure t)

(use-package doom-modeline
      :ensure t
      :hook (after-init . doom-modeline-mode))

(use-package winum :ensure t)
(winum-mode)

(use-package recentf 
	:ensure t
	:config
	(recentf-mode 1))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package evil-magit
  :ensure t)

(use-package snippet :ensure t)

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

(use-package flycheck :ensure t)

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :init (ivy-mode 1) ; globally at startup
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 20)
  (setq ivy-count-format "%d/%d "))


(use-package counsel
  :ensure t
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
    which-key-side-window-max-width 0.33
    which-key-idle-delay 0.05)
  :diminish which-key-mode)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "bs" 'ivy-switch-buffer
   "bS" 'ivy-switch-buffer-other-window
   "bk" 'kill-current-buffer
   "bh" 'bs-show
   "bl" 'list-buffers
   "en" 'next-error
   "ep" 'previous-error
   "wk" 'my-kill-buffer-and-window
   "w0" 'winum-select-window-0-or-10
   "w1" 'winum-select-window-1
   "w2" 'winum-select-window-2
   "w3" 'winum-select-window-3
   "w4" 'winum-select-window-4
   "w5" 'winum-select-window-5
   "w6" 'winum-select-window-6
   "w7" 'winum-select-window-7
   "w8" 'winum-select-window-8
   "w9" 'winum-select-window-9
   "o" 'omnisharp-start-omnisharp-server
   "gt" 'omnisharp-navigate-to-solution-member
   "gT" 'omnisharp-navigate-to-solution-member-other-window
   "yn" 'yas-new-snippet
   "ys" 'yas-insert-snippet
   "yv" 'yas-visit-snippet-file
   ))

(use-package csharp-mode
  :ensure t
  :init (add-hook 'csharp-mode-hook 'my-csharp-mode-setup)
:mode "\\.cs")

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (flycheck-mode))

;; Omnisharp
(use-package omnisharp
  :ensure t
  :after csharp-mode
  :preface
  (progn
    (defun my/configure-omnisharp ()
      (omnisharp-mode)
      (add-to-list 'company-backends #'company-omnisharp)
      (company-mode)
      (general-define-key
       :keymaps 'omnisharp-mode-map
       :states '(normal)
       :prefix "SPC"
       "gd" 'omnisharp-go-to-definition
       "gD" 'omnisharp-go-to-definition-other-window
       "fu" 'omnisharp-find-usages
       "fi" 'omnisharp-find-implementations
       "gm" 'omnisharp-navigate-to-current-file-member
       "gf" 'omnisharp-navigate-to-solution-file
       "gr" 'omnisharp-run-code-action-refactoring
       "sfh" 'snip-file-header
       "sfr" 'snip-file-revision
       "sch" 'snip-class-header
       "scr" 'snip-class-revision
       "smh" 'snip-method-header
       "smr" 'snip-method-revision
       "smp" 'snip-method-param1
       "smt" 'snip-method-return
       "ss" 'snip-summary
       "sp" 'snip-property-header
       "sx" 'format-xml-comment
       "su" 'snip-external-unit
       "sv" 'snip-value
       "sco" 'snip-construct
       "se" 'snip-exception
       )))
  :init
  (add-hook 'csharp-mode-hook #'my/configure-omnisharp)
  )

(add-to-list 'auto-mode-alist '("\\.xaml$" . nxml-mode))
 
(use-package js2-mode
  :ensure t
  :defer t
  :commands js2-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (setq-default js2-basic-offset 4)
    (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode)))
  :config
  (progn
    (js2-imenu-extras-setup)
    ))

(use-package tern
  :ensure t
  :defer t
  :config
  (progn
    (add-hook 'js2-mode-hook 'tern-mode)))

;; (use-package company-tern
;;   :ensure t
;;   :defer t
;;   :init
;;   (progn
;;     (require 'company)
;;     (add-to-list 'company-backends 'company-tern)))

(use-package ag
  :ensure t)

(use-package flyspell
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (add-hook 'text-mode-hook 'flyspell-mode)
    )
  )

(use-package markdown-mode
  :ensure t
  :preface
  (defun my/configure-markdown ()
    (general-define-key
     :keymaps 'markdown-mode-map
     :states '(normal visual insert emacs)
     :prefix "SPC"
     :non-normal-prefix "C-SPC"
     "mc" 'my-compile-markdown
     "mh" 'snip-markdown-header
     "mj" 'snip-jira-link
     "ml" 'markdown-insert-link
     "mo" 'markdown-follow-thing-at-point
     ))
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (add-hook 'markdown-mode-hook #'my/configure-markdown)
    )

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil))

(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)))

(use-package cider
  :ensure t
  :defer t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t    
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        nrepl-hide-special-buffers t            
        cider-overlays-use-font-lock t)         
  (cider-repl-toggle-pretty-printing))

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

(load "~/.emacs.d/funcs.el")
(load "~/.emacs.d/config.el")
(load "~/.emacs.d/keybindings.el")

(dave-config)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(display-line-numbers 'relative)
 '(doom-modeline-buffer-file-name-style 'buffer-name)
 '(indent-tabs-mode nil)
 '(ispell-program-name "aspell")
 '(markdown-command "pandoc -f markdown -t html")
 '(package-selected-packages
   '(evil-collection cider clojure-mode diminish yasnippet-snippets yasnippet auctex evil-magit general ag js2-mode omnisharp company magit hc-zenburn-theme markdown-mode ivy counsel csharp-mode snippet evil undo-tree use-package))
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-buffer-modified ((t (:foreground "DeepPink3"))))
 '(doom-modeline-evil-emacs-state ((t (:foreground "#5E5BA8"))))
 '(doom-modeline-evil-insert-state ((t (:foreground "cyan"))))
 '(doom-modeline-evil-normal-state ((t (:foreground "yellow"))))
 '(doom-modeline-evil-visual-state ((t (:foreground "OrangeRed1")))))
