(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq inhibit-startup-message t) 

(add-to-list 'default-frame-alist '(font . "Lucida Console-9"))

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
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

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(set-face-foreground 'line-number "#5D5D5D")

(use-package all-the-icons)

(use-package doom-modeline
      :hook (after-init . doom-modeline-mode))

(use-package winum)
(winum-mode)

(use-package recentf 
	:config
	(recentf-mode 1))

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

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(dsa/define-key
   "p" '(:keymap projectile-command-map :wk "Projectile")
   )

(use-package smartparens)
(require 'smartparens-config)

(use-package evil-cleverparens)
(require 'evil-cleverparens-text-objects)

(require 'init-lsp)
(require 'init-csharp)

(require 'init-javascript)

(require 'init-python-lsp)

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
  (setq TeX-PDF-mode t)
  (setq-default TeX-master nil))

(show-paren-mode 1)

(defun dsa/lisp-hook ()
  (smartparens-mode)
  (smartparens-strict-mode)
  (evil-cleverparens-mode))

(define-key lisp-mode-shared-map "\C-m" 'newline-and-indent)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq tab-width 8)
            (dsa/lisp-hook)))

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

(mouse-avoidance-mode 'banish)
(set-tab-stops)
(toggle-frame-fullscreen)
(split-window-right)
(other-window 1)
(server-start)
(global-auto-revert-mode)
(eshell)
