(defun eshell/c (src &optional dest)
  (eshell/cp "-pv" src (or dest ".")))

(defun eshell/m (src &optional dest)
  (eshell/mv "-fv" src (or dest ".")))

(defun eshell/de (&optional args)
  (dired (or args ".")))

(defun eshell/deo (&optional args)
  (dired-other-window (or args ".")))

(defun eshell/start (FILE)
  "Invoke (w32-shell-execute \"Open\" FILE) and substitute slashes for backslashes"
  (w32-shell-execute "Open" (substitute ?\\ ?/ (expand-file-name FILE)))
  nil)

(defalias 'eshell/e 'find-file)
(defalias 'eshell/eo 'find-file-other-window)
(defalias 'eshell/he 'hexl-find-file)

(provide 'init-eshell)
