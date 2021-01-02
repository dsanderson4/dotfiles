(defun set-tab-stops ()
  (interactive)
  (setq tab-stop-list nil)
  (let ((stop tab-width))
    (while (< stop 200)
      (setq tab-stop-list (append tab-stop-list (list stop))
            stop (+ stop tab-width)))))

(defun set-tab-width (width)
  (interactive "nTab Width: ")
  (setq tab-width width)
  (setq c-basic-offset width)
  (set-tab-stops)
  (redraw-display))

(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1))

(defun line-to-top ()
  (interactive)
  (recenter 0))

(defun line-to-bottom ()
  (interactive)
  (recenter (- (window-height) 2)))

(defun tab-width-2 ()
  (interactive)
  (set-tab-width 2))

(defun tab-width-3 ()
  (interactive)
  (set-tab-width 3))

(defun tab-width-4 ()
  (interactive)
  (set-tab-width 4))

(defun tab-width-5 ()
  (interactive)
  (set-tab-width 5))

(defun tab-width-8 ()
  (interactive)
  (set-tab-width 8))

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer nil))

(defun my-copy-to-register (register start end)
  (interactive "cCopy to register: \nr")
  (copy-to-register register start end)
  (deactivate-mark))

(defun my-insert-register (register)
  (interactive "cInsert register: ")
  (insert-register register t))

(defun cut-to-register (register start end)
  (interactive "cCut to register: \nr")
  (set-register register (buffer-substring start end))
  (delete-region start end))

(defun my-kill-buffer-and-window ()
  "Kill the current buffer and delete the selected window."
  (interactive)
  (let ((buffer (current-buffer)))
    (delete-window (selected-window))
    (kill-buffer buffer)))

(defun toggle-trailing-whitespace ()
  (interactive)
  (if show-trailing-whitespace
      (progn
        (setq show-trailing-whitespace nil)
        (message "Trailing whitespace hidden"))
    (setq show-trailing-whitespace t)
    (message "Trailing whitespace displayed"))
  (redraw-display))

(defun end-of-header ()
  (interactive)
  (search-forward "*/")
  (beginning-of-line))

(defun my-vertical-split (other-buffer)
  (interactive "bOther buffer: ")
  (delete-other-windows)
  (split-window-horizontally)
  (switch-to-buffer other-buffer)
  (other-window 1))

(defun split-window-more-sensibly (window)
  (if (one-window-p)
      (split-window-sensibly window)
    (nil)))

(defun my-vc-dir-hide-some ()
  (interactive)
  (vc-dir-hide-state 'unregistered))

(defun dired-shell-execute ()
  (interactive)
  (w32-shell-execute "Open" (substitute ?\\ ?/ (dired-get-filename))))

(defun my-dired-load-hook ()
  (define-key dired-mode-map "\C-o" 'other-window)
  (define-key dired-mode-map "\C-d" 'dired-display-file)
  (define-key dired-mode-map "r" 'dired-shell-execute))
;;(add-hook 'dired-load-hook 'my-dired-load-hook)

(defun my-dired-mode-hook ()
  (setq bs-buffer-show-mark 'always))

(defun outline-fill-paragraph ()
  (interactive)
  (save-excursion
    (search-backward "-")
    (delete-char 1)
    (insert " ")
    (fill-paragraph)
    (backward-char 1)
    (insert "-")
    (delete-char 1)
    ))

(defun my-new-outline ()
  (interactive)
  (outline-mode)
  (setq outline-regexp "\\(  \\)*- ")
  (insert "-*- mode: Outline; outline-regexp: \"\\\\(  \\\\)*- \" -*-\n"))

(defun my-tags ()
  (interactive)
  (when (get-buffer "TAGS")
    (kill-buffer "TAGS"))
  (require 'etags)
  (tags-reset-tags-tables)
  (visit-tags-table "TAGS")
  (set-buffer "TAGS")
  (message "Loaded tags %s" (buffer-file-name))
  (setq bs-buffer-show-mark 'never))

(defun flatten-paragraph ()
  (interactive)
  (let ((save-fill-column fill-column))
    (unwind-protect
        (progn
          (setq fill-column 1000000)
          (fill-paragraph 1))
      (setq fill-column save-fill-column))
    (forward-paragraph 1)))

(defun my-units-called ()
  (interactive)
  (recenter 2)
  (split-window-vertically)
  (shrink-window 28)
  (other-window 1)
  (end-of-header)
  (recenter 0)
  (other-window 1))

(defun format-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char start)
    (fill-paragraph nil)))

(defun format-xml-comment ()
  (interactive)
  (let ((m (point-marker)) (start))
    (search-backward "// <")
    (forward-line 1)
    (setq start (point))
    (search-forward "// </")
    (forward-line 0)
    (save-restriction
      (narrow-to-region start (point))
      (goto-char (point-min))
      (fill-paragraph nil)
      )
    (goto-char m)
    (set-marker m nil)
    )
  )

(defun insert-guid ()
  (interactive)
  (insert (substring (shell-command-to-string "\"c:/Program Files (x86)/Windows Kits/10/bin/10.0.18362.0/x86/uuidgen.exe\" -c") 0 -1)))


(defun reverse-revision-history (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (let ((revs) (rev-start) (rev-end))
      (beginning-of-buffer)
      (while (looking-at " */* <revision")
        (setq rev-start (point))
        (search-forward "</revision>")
        (forward-line 1)
        (setq rev-end (point))
        (setq revs (cons (buffer-substring rev-start rev-end) revs))
        (delete-region rev-start rev-end))
      (while revs
        (insert (car revs))
        (setq revs (cdr revs))))))

(defun open-xml-comment ()
  (interactive)
  (forward-line 0)
  (search-forward ">")
  (newline-and-indent)
  (insert "///     ")
  (search-forward "<")
  (backward-char 1)
  (newline-and-indent)
  (insert "/// ")
  (forward-line 0)
  (backward-char 1)
  )

(defun dave-config ()
  (load-library "bs")

  (set-tab-stops)

  (eval-after-load "vc-dir"
    '(evil-define-key 'normal vc-dir-mode-map "h" 'my-vc-dir-hide-some))

  (add-hook 'text-mode-hook 'turn-on-auto-fill)

  (define-key lisp-mode-shared-map "\C-m" 'newline-and-indent)

  (add-hook 'emacs-lisp-mode-hook
            '(lambda ()
               (setq tab-width 8)))

  (eval-after-load "dired" '(my-dired-load-hook))
  (add-hook 'dired-mode-hook 'my-dired-mode-hook)

  ;; (add-hook 'outline-mode-hook
  ;;           '(lambda ()
  ;;              (define-key outline-mode-map "\M-q" 'outline-fill-paragraph)))

  (add-hook 'vc-svn-log-view-mode-hook
            '(lambda ()
               (evil-define-key 'normal vc-svn-log-view-mode-map "n" 'log-view-msg-next)
               (evil-define-key 'normal vc-svn-log-view-mode-map "p" 'log-view-msg-prev)))

  (mouse-avoidance-mode 'banish)

  (setq split-window-preferred-function (quote split-window-more-sensibly))

  (evil-set-initial-state 'bs-mode 'emacs)
  (toggle-frame-fullscreen)
  (split-window-right)
  (other-window 1)
  (eshell)
  (server-start)
  (global-auto-revert-mode)
  )

(provide 'init-global-functions)