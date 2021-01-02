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
    "ol" '(org-insert-link :which-key "Insert Link")
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

(provide 'init-org)
