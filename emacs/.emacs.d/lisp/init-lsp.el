(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-file-watch-threshold 9999)
  :commands lsp lsp-deferred)

(dsa/define-key
  "l" '(:keymap lsp-command-map :which-key "LSP" :package lsp-mode))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(dsa/define-key
  :keymaps 'lsp-mode-map

  "g" '(:ignore t :which-key "Go")
  "gt" '(xref-find-apropos :which-key "Symbol")
  "gd" '(lsp-find-definition :which-key "Definition")
  "gm" '(counsel-imenu :which-key "File Member")
  "ga" '(lsp-execute-code-action :which-key "Action")

  "f" '(:ignore t :which-key "Find")
  "fu" '(lsp-find-references :which-key "Usages")
  "fi" '(lsp-find-implementation :which-key "Implementations"))
  
(use-package dap-mode
  :config
  (require 'dap-node)
  (require 'dap-chrome)
  (require 'dap-python)
  (dap-node-setup))

(setq warning-minimum-level :error)

(provide 'init-lsp)
