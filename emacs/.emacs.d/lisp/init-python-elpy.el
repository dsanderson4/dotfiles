(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
        ("\\.wsgi$" . python-mode)
  :interpreter ("python" . python-mode)

  :init
  (setq-default indent-tabs-mode nil)

  :config
  (setq python-indent-offset 4)
  )

(use-package elpy
  :commands elpy-enable
  :init (with-eval-after-load 'python (elpy-enable))

  :config
  (electric-indent-local-mode -1)
  :custom
  (elpy-rpc-backend "jedi"))

(provide 'init-python-elpy  (use-package company-jedi
    :ensure t
    :defer t
    :init
    (defun enable-jedi()
      (setq-local company-backends
                  (append '(company-jedi) company-backends)))
    (with-eval-after-load 'company
      (add-hook 'python-mode-hook 'enable-jedi))))
