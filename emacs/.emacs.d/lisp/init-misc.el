(require 'bs)
(evil-set-initial-state 'bs-mode 'emacs)

(eval-after-load "vc-dir"
  '(evil-define-key 'normal vc-dir-mode-map "h" 'my-vc-dir-hide-some))

(add-hook 'vc-svn-log-view-mode-hook
          '(lambda ()
             (evil-define-key 'normal vc-svn-log-view-mode-map "n" 'log-view-msg-next)
             (evil-define-key 'normal vc-svn-log-view-mode-map "p" 'log-view-msg-prev)))

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(define-key lisp-mode-shared-map "\C-m" 'newline-and-indent)

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (setq tab-width 8)))

(provide 'init-misc)
