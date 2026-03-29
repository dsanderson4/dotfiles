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
    "h" 'dired-up-directory
     (kbd "M-e") 'dired-shell-execute)
  (setq dired-dwim-target t)
  (setq dired-kill-when-opening-new-dired-buffer t))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package ranger
  :init
  (setq ranger-cleanup-eagerly nil
        ranger-show-hidden t
        ranger-hide-cursor t
        ranger-max-preview-size 10))

(provide 'init-dired)
