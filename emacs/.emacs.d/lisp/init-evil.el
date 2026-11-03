(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

;; <C-]><letter> alternates for default left-hand Ctrl chords, since recent
;; laptops dropped the right Ctrl key and these are awkward as same-hand chords.
;; This takes over the bare C-] binding (evil-jump-to-tag), which moves to
;; C-] ] instead, since Emacs can't let C-] both fire immediately and act as
;; a prefix for the sequences below.
(defun dsa/replay-ctrl (letter)
  "Return a command that runs whatever C-LETTER is currently bound to.
Builds the lambda via backquote so the key is a literal baked into the
returned form, since this file isn't lexically scoped and a closure over
LETTER would go void by the time the command is actually invoked."
  (let ((key (kbd (concat "C-" letter))))
    `(lambda ()
       (interactive)
       (let ((cmd (key-binding ,key)))
         (when cmd (call-interactively cmd))))))

(define-key evil-motion-state-map (kbd "C-]") nil)
(define-key evil-motion-state-map (kbd "C-] ]") 'evil-jump-to-tag)
(dolist (letter '("a" "b" "d" "e" "f" "g" "r" "t" "v" "z"))
  (define-key evil-motion-state-map (kbd (concat "C-] " letter)) (dsa/replay-ctrl letter)))

(dolist (letter '("a" "d" "e" "r" "t" "v" "w" "x"))
  (define-key evil-insert-state-map (kbd (concat "C-] " letter)) (dsa/replay-ctrl letter)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-escape
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  :config
  (evil-escape-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package undo-tree
  :config
  (global-undo-tree-mode 1))

(provide 'init-evil)
