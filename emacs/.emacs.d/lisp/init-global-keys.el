(use-package which-key
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
    which-key-side-window-max-width 0.33
    which-key-idle-delay 0.05)
  :diminish which-key-mode)

(use-package general
  :config
  (general-create-definer dsa/define-key
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "C-SPC"))

(dsa/define-key
 :keymaps 'override

 "TAB" '(indent-for-tab-command :which-key "Indent")

 "b" '(:ignore t :which-key "Buffer")
 "bs" '(ivy-switch-buffer :which-key "Switch")
 "bS" '(ivy-switch-buffer-other-window :which-key "Switch - Other Window")
 "bk" '(kill-current-buffer :which-key "Kill Current")
 "bh" '(bs-show :which-key "Show Buffers")
 "bi" '(ibuffer :which-key "ibuffer")
 "bI" '(ibuffer-other-window :which-key "ibuffer - Other Window")
 "bl" '(list-buffers :which-key "List Buffers")

 "e" '(:ignore t :which-key "Error")
 "en" '(next-error :which-key "Next")
 "ep" '(previous-error :which-key "Previous")

 "w" '(:ignore t :which-key "Window")
 "wx" '(my-kill-buffer-and-window :which-key "Kill buffer and Window")
 "w0" '(winum-select-window-0-or-10 :which-key "Select 0 or 10")
 "w1" '(winum-select-window-1 :which-key "Select 1")
 "w2" '(winum-select-window-2 :which-key "Select 2")
 "w3" '(winum-select-window-3 :which-key "Select 3")
 "w4" '(winum-select-window-4 :which-key "Select 4")
 "w5" '(winum-select-window-5 :which-key "Select 5")
 "w6" '(winum-select-window-6 :which-key "Select 6")
 "w7" '(winum-select-window-7 :which-key "Select 7")
 "w8" '(winum-select-window-8 :which-key "Select 8")
 "w9" '(winum-select-window-9 :which-key "Select 9")
 "wf" '(toggle-frame-fullscreen :which-key "Toggle Fullscreen")
 "wj" '(evil-window-down :which-key "Down")
 "wk" '(evil-window-up :which-key "Up")
 "wh" '(evil-window-left :which-key "Left")
 "wl" '(evil-window-right :which-key "Right")
 "ww" '(evil-window-next :which-key "Next")
 "wr" '(evil-window-rotate-downwards :which-key "Rotate")

 "y" '(:ignore t :which-key "yasnippet")
 "yn" '(yas-new-snippet :which-key "New")
 "ys" '(yas-insert-snippet :which-key "Insert")
 "yv" '(yas-visit-snippet-file :which-key "Visit File")

 "j" '(:ignore t :which-key "Jump")
 "jl" '(avy-goto-line :which-key "Line")
 "jW" '(avy-goto-word-0 :which-key "Word 0")
 "jw" '(avy-goto-word-1 :which-key "Word 1")
 "jc" '(avy-goto-char :which-key "Char")
 "jt" '(avy-goto-char-timer :which-key "Char Timer")
 )

(global-set-key (kbd "<C-lwindow>") 'ignore)

(global-set-key [C-tab] 'bs-cycle-next)
(global-set-key "\C-o" 'other-window)
(global-set-key [?\C-%] 'shrink-window)
(global-set-key [?\C-^] 'enlarge-window)
(global-set-key [?\C-&] 'shrink-window-horizontally)
(global-set-key [?\C-*] 'enlarge-window-horizontally)

(global-set-key [M-backspace] 'advertised-undo)
(global-set-key "\M-]" 'scroll-up-1)
(global-set-key "\M-[" 'scroll-down-1)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-o" 'find-file)
(global-set-key "\C-x\C-b" 'bs-show)

(global-set-key "\C-c2" 'tab-width-2)
(global-set-key "\C-c3" 'tab-width-3)
(global-set-key "\C-c4" 'tab-width-4)
(global-set-key "\C-c5" 'tab-width-5)
(global-set-key "\C-c8" 'tab-width-8)
(global-set-key "\C-ca" 'flatten-paragraph)
(global-set-key "\C-cb" 'line-to-bottom)
(global-set-key "\C-cc" 'my-copy-to-register)
(global-set-key "\C-cd" 'delete-trailing-whitespace)
(global-set-key "\C-ce" 'eshell)
(global-set-key "\C-cf" 'recentf-open-files)
(global-set-key "\C-cg" 'bookmark-jump)
(global-set-key "\C-ch" 'toggle-trailing-whitespace)
(global-set-key "\C-ci" 'my-insert-register)
(global-set-key "\C-cj" 'end-of-header)
(global-set-key "\C-cm" 'recenter)
(global-set-key "\C-cn" 'rm-set-mark)
(global-set-key "\C-cp" 'joc-print-buffer-or-region)
(global-set-key "\C-cq" 'kill-current-buffer)
(global-set-key "\C-cr" 'query-replace)
(global-set-key "\C-cs" 'bookmark-set)
(global-set-key "\C-ct" 'line-to-top)
(global-set-key "\C-cv" 'my-vertical-split)
(global-set-key "\C-cw" 'my-kill-buffer-and-window)
(global-set-key "\C-cx" 'cut-to-register)
(global-set-key "\C-cy" 'browse-kill-ring)

(global-set-key "\C-czfh" 'snip-file-header)
(global-set-key "\C-czfr" 'snip-file-revision)

(global-set-key "\C-czfx" 'format-xml-comment)

(global-set-key "\C-czch" 'snip-class-header)
(global-set-key "\C-czcr" 'snip-class-revision)

(global-set-key "\C-czeu" 'snip-external-unit)

(global-set-key "\C-czmr" 'snip-method-revision)
(global-set-key "\C-czmh" 'snip-method-header)

(global-set-key "\C-czph" 'snip-property-header)

(global-set-key "\C-czs" 'snip-summary)

(provide 'init-global-keys)
