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

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package diminish)

(require 'init-evil)

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

(use-package snippet)

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package flycheck)

(require 'init-ivy)

(require 'init-global-keys)

(use-package company
  :config
  (global-company-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package command-log-mode
  :config
  (global-command-log-mode))

(use-package helpful)

(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)

(require 'init-csharp)

(require 'init-javascript)

(use-package powershell)

(require 'init-org)

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

(require 'init-clojure)
(require 'init-global-functions)
(require 'init-snippets)
(require 'init-eshell)
(require 'init-dired)
(require 'init-buffers)
(require 'init-vc)

(dolist (mode '(eshell-mode-hook
                bs-mode-hook))
  (add-hook mode (lambda () (setq display-line-numbers nil))))

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(define-key lisp-mode-shared-map "\C-m" 'newline-and-indent)

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (setq tab-width 8)))

(mouse-avoidance-mode 'banish)
(set-tab-stops)
(toggle-frame-fullscreen)
(split-window-right)
(other-window 1)
(eshell)
(server-start)
(global-auto-revert-mode)
