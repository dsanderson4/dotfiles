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

 "x" '(:ignore t :which-key "Misc 1")
 "xc" '(save-buffers-kill-terminal :which-key "Exit")
 "xe" '(eshell :which-key "Eshell")
 "xf" '(counsel-find-file :which-key "Find File")
 "xF" '(find-file-other-window :which-key "Find File Other Window")
 "xg" '(magit-status :which-key "Magit Status")
 "xT" '(global-treesit-auto-mode :which-key "Global Treesit Auto Mode")
 "xs" '(save-buffer :which-key "Save Buffer")
 "xS" '(save-some-buffers :which-key "Save Some Buffers")

 "xt" '(:ignore t :which-key "Tab Width")
 "xt2" '(tab-width-2 :which-key "2")
 "xt3" '(tab-width-3 :which-key "3")
 "xt4" '(tab-width-4 :which-key "4")
 "xt5" '(tab-width-5 :which-key "5")
 "xt8" '(tab-width-8 :which-key "8")

 "xv" '(:ignore t :which-key "Version Control")
 "xv=" '(vc-diff :which-key "Diff")
 "xvd" '(vc-dir :which-key "Dir")
 "xve" '(vc-revision-other-window :which-key "Revision")
 "xvl" '(vc-print-log :which-key "Log")
 "xvn" '(vc-next-action :which-key "Next Action")
 "xvr" '(vc-revert :which-key "Revert")

 "c" '(:ignore t :which-key "Misc 2")
 "ca" '(flatten-paragraph :which-key "Flatten Paragraph")
 "cd" '(delete-trailing-whitespace :which-key "Delete Trailing Whitespace")
 "cr" '(query-replace :which-key "Query Replace")
 "cv" '(my-vertical-split :which-key "Vertical Split")

 "b" '(:ignore t :which-key "Buffer")
 "bs" '(ivy-switch-buffer :which-key "Switch")
 "bS" '(ivy-switch-buffer-other-window :which-key "Switch - Other Window")
 "bk" '(kill-current-buffer :which-key "Kill Current")
 "bh" '(bs-show :which-key "Show Buffers")
 "bi" '(ibuffer :which-key "ibuffer")
 "bI" '(ibuffer-other-window :which-key "ibuffer - Other Window")
 "bl" '(list-buffers :which-key "List Buffers")
 "bq" '(my-kill-buffer-and-window :which-key "Kill buffer and window")

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

 "h" '(:ignore t :which-key "Describe")
 "hk" '(describe-key :which-key "Key")
 "hf" '(counsel-describe-function :which-key "Function")
 "hm" '(describe-mode :which-key "Mode")
 "hv" '(counsel-describe-variable :which-key "Variable")

 "u" '(universal-argument :which-key "Universal Argument")
 )

(global-set-key (kbd "<C-lwindow>") 'ignore)

(global-set-key [C-tab] 'bs-cycle-next)
(global-set-key [?\C-%] 'shrink-window)
(global-set-key [?\C-^] 'enlarge-window)
(global-set-key [?\C-&] 'shrink-window-horizontally)
(global-set-key [?\C-*] 'enlarge-window-horizontally)

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

(provide 'init-global-keys)
