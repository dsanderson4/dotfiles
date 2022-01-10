(use-package dired
  :ensure nil
  :config
  (defun dired-shell-execute ()
    (interactive)
    (os-start-file (dired-get-filename)))
  (add-hook 'dired-mode-hook
            (lambda ()
              (setq bs-buffer-show-mark 'always)))
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer
     (kbd "M-e") 'dired-shell-execute)
  (setq dired-dwim-target t))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package ranger
  :init
  (setq ranger-cleanup-eagerly nil
        ranger-show-hidden t
        ranger-hide-cursor t
        ranger-max-preview-size 10))

(provide 'init-dired)
