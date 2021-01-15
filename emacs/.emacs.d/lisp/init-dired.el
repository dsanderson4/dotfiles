(use-package dired
  :ensure nil
  :config
  (defun dired-shell-execute ()
    (interactive)
    (w32-shell-execute "Open" (substitute ?\\ ?/ (dired-get-filename))))
  (add-hook 'dired-mode-hook
            (lambda ()
              (setq bs-buffer-show-mark 'always))
            )
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer
     "M-e" 'dired-shell-execute
    )
  )

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(provide 'init-dired)
