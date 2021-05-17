(require 'bs)
(evil-set-initial-state 'bs-mode 'emacs)

(setq ibuffer-formats 
      '((mark modified read-only " "
              (name 30 30 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("elisp" (mode . emacs-lisp-mode))
               ("C#" (or
                      (name . "^.*\.cs$")
                      (name . "^.*\.xaml$")
                      (name . "^.*\.igr$")
                      (name . "^.*\.resx$")
                      (name . "app.config")
                      ))
               ("Writing" (or
                      (name . "^.*\.org$")
                      (name . "^.*\.md$")
                      (name . "^.*\.tex$")
                      (name . "^.*\.txt$")
                      ))
               ("emacs" (name . "^\\*.*\\*$"))
             ))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")
            (ibuffer-auto-mode 1)))

(provide 'init-buffers)
