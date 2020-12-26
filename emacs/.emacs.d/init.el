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
(setq use-package-always-ensure t)

(use-package diminish)

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-escape
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  :config
  (evil-escape-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package avy)

(use-package hc-zenburn-theme
  :config
  (load-theme 'hc-zenburn t))

(custom-theme-set-faces
 'hc-zenburn
 '(line-number-current-line ((t (:foreground "#A0EDF0"))))
)

(use-package all-the-icons)

(use-package doom-modeline
      :hook (after-init . doom-modeline-mode))

(use-package winum)
(winum-mode)

(use-package recentf 
	:config
	(recentf-mode 1))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package snippet)

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package flycheck)

(use-package ivy
  :diminish (ivy-mode . "")
  :bind (
         :map ivy-minibuffer-map
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
         
  :init (ivy-mode 1) ; globally at startup
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 20)
  (setq ivy-count-format "%d/%d "))


(use-package counsel
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
   ("C-h f"  . counsel-describe-function)
   ("C-h v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

(use-package which-key
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
    which-key-side-window-max-width 0.33
    which-key-idle-delay 0.05)
  :diminish which-key-mode)

(use-package company
  :config
  (global-company-mode))

(use-package general
  :config
  (general-create-definer dsa/define-key
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "C-SPC"))

(dsa/define-key
 :keymaps 'override
 "b" '(:ignore t :which-key "Buffer")
 "bs" '(ivy-switch-buffer :which-key "Switch")
 "bS" '(ivy-switch-buffer-other-window :which-key "Switch - Other Window")
 "bk" '(kill-current-buffer :which-key "Kill Current")
 "bh" '(bs-show :which-key "Show Buffers")
 "bl" '(list-buffers :which-key "List Buffers")

 "e" '(:ignore t :which-key "Error")
 "en" '(next-error :which-key "Next")
 "ep" '(previous-error :which-key "Previous")

 "w" '(:ignore t :which-key "Window")
 "wk" '(my-kill-buffer-and-window :which-key "Kill buffer and Window")
 "w0" '(winum-select-window-0-or-10 :which-key "Select 0 or 10")
 "w1" '(winum-select-window-1 :which-key "Select 1")
 "w2" '(winum-select-window-2 :which-key "Select 2")
 "w3" '(winum-select-window-3 :which-key "Select 3")
 "w4" '(winum-select-window-4 :which-key "Select 4")
 "w5" '(winum-select-window-5 :which-key "Select 5")
 "w6" '(winum-select-window-6 :which-key "Select 6")
 "w7" '(winum-select-window-7 :which-key "Select 7")
 "w8" '(winum-select-window-8 :which-key "Select 8")
 "w9" '(winum-select-window-9 :which-key "Select 9")
 "wf" '(toggle-frame-fullscreen :which-key "Toggle Fullscreen")

 "g" '(:ignore t :which-key "Omnisharp Go")
 "gs" '(omnisharp-start-omnisharp-server :which-key "Start Server")
 "gt" '(omnisharp-navigate-to-solution-member :which-key "Go to Solution Member")
 "gT" '(omnisharp-navigate-to-solution-member-other-window :which-key "Go to Solution Member, Other Window")
 "gf" '(omnisharp-navigate-to-solution-file :which-key "Go to Solution File")

 "y" '(:ignore t :which-key "yasnippet")
 "yn" '(yas-new-snippet :which-key "New")
 "ys" '(yas-insert-snippet :which-key "Insert")
 "yv" '(yas-visit-snippet-file :which-key "Visit File")

 "j" '(:ignore t :which-key "Jump")
 "jl" '(avy-goto-line :which-key "Line")
 "jW" '(avy-goto-word-0 :which-key "Word 0")
 "jw" '(avy-goto-word-1 :which-key "Word 1")
 "jc" '(avy-goto-char :which-key "Char")
 "jt" '(avy-goto-char-timer :which-key "Char Timer")
 )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package command-log-mode
  :config
  (global-command-log-mode))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful)

(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)

(use-package csharp-mode
  :init (add-hook 'csharp-mode-hook 'my-csharp-mode-setup)
  :mode "\\.cs")

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (flycheck-mode))

;; Omnisharp
(use-package omnisharp
  :after csharp-mode
  :preface
    (defun my/configure-omnisharp ()
      (omnisharp-mode)
      (add-to-list 'company-backends #'company-omnisharp)
      (company-mode)
      (dsa/define-key
       :keymaps 'omnisharp-mode-map
       "gd" '(omnisharp-go-to-definition :which-key "Definition")
       "gD" '(omnisharp-go-to-definition-other-window :which-key "Definition, Other Window")
       "gm" '(omnisharp-navigate-to-current-file-member :which-key "File Member")
       "gr" '(omnisharp-run-code-action-refactoring :which-key "Refactoring")

       "f" '(:ignore t :which-key "Omnisharp Find")
       "fu" '(omnisharp-find-usages :which-key "Usages")
       "fi" '(omnisharp-find-implementations :which-key "Implementations")

       "s" '(:ignore t :which-key "C# Snippets")
       "se" '(snip-exception :which-key "Exception")
       "sp" '(snip-property-header :which-key "Property Header")
       "ss" '(snip-summary :which-key "Summary")
       "su" '(snip-external-unit :which-key "External Unit")
       "sx" '(format-xml-comment :which-key "Format XML Comment")
       "sv" '(snip-value :which-key "Value")

       "sf" '(:ignore t :which-key "File")
       "sfh" '(snip-file-header) :which-key "File Header")
       "sfr" '(snip-file-revision :which-key "File Revision")

       "sc" '(:ignore t :which-key "Class")
       "sch" '(snip-class-header :which-key "Class Header")
       "scr" '(snip-class-revision :which-key "Class Revision")
       "sco" '(snip-construct :which-key "Constructor")

       "sm" '(:ignore t :which-key "Method")
       "smh" '(snip-method-header :which-key "Header")
       "smr" '(snip-method-revision :which-key "Revision")
       "smp" '(snip-method-param1 :which-key "Parameter")
       "smt" '(snip-method-return :which-key "Return")
       )
  :init
  (add-hook 'csharp-mode-hook #'my/configure-omnisharp)
  )

(add-to-list 'auto-mode-alist '("\\.xaml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.igr$" . nxml-mode))
 
(use-package js2-mode
  :defer t
  :commands js2-mode
  :init
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (setq-default js2-basic-offset 4)
    (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode))
  :config
    (js2-imenu-extras-setup)
    )

(use-package tern
  :defer t
  :config
    (add-hook 'js2-mode-hook 'tern-mode))

(use-package powershell)

(defun dsa/insert-org-options ()
  (interactive)
  (insert "#+OPTIONS: toc:nil html-postamble:nil num:nil\n"))

(use-package org
  :ensure org-plus-contrib
  :pin org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-indent-mode-turns-on-hiding-stars nil)
  (dsa/define-key
    :keymaps 'org-mode-map
    "o" '(:ignore t :which-key "Org")
    "oe" '(org-export-dispatch :which-key "Export")
    "oo" '(dsa/insert-org-options :which-key "Insert Default Options")
    ))

(require 'ox-md)

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package ag)

(use-package flyspell
  :defer t
  :init
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (add-hook 'text-mode-hook 'flyspell-mode)
  )

(use-package markdown-mode
  :preface
  (defun my/configure-markdown ()
    (dsa/define-key
     :keymaps 'markdown-mode-map
     "m" '(:ignore t :which-key "Markdown")
     "mc" '(my-compile-markdown :which-key "Compile")
     "mh" '(snip-markdown-header :which-key "Insert Header")
     "mj" '(snip-jira-link :which-key "Insert JIRA Link")
     "ml" '(markdown-insert-link :which-key "Insert Link")
     "mo" '(markdown-follow-thing-at-point :which-key "Follow")
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
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)))

(use-package cider
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
   '(helpful ivy-rich rainbow-delimiters command-log-mode evil-org powershell evil evil-commentary evil-collection cider clojure-mode diminish yasnippet-snippets yasnippet auctex general ag js2-mode omnisharp company magit hc-zenburn-theme markdown-mode ivy counsel csharp-mode snippet evil undo-tree use-package))
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
