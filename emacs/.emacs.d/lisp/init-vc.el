(use-package magit
  :bind (("C-x g" . magit-status)))

(eval-after-load "vc-dir"
  '(evil-define-key 'normal vc-dir-mode-map "h" 'my-vc-dir-hide-some))

(add-hook 'vc-svn-log-view-mode-hook
          '(lambda ()
             (evil-define-key 'normal vc-svn-log-view-mode-map "n" 'log-view-msg-next)
             (evil-define-key 'normal vc-svn-log-view-mode-map "p" 'log-view-msg-prev)))

(provide 'init-vc)
