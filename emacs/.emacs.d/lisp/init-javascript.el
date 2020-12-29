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

(provide 'init-javascript)
