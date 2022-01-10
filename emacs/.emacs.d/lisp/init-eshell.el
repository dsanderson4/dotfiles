(defun eshell/c (src &optional dest)
  (eshell/cp "-pv" src (or dest ".")))

(defun eshell/m (src &optional dest)
  (eshell/mv "-fv" src (or dest ".")))

(defun eshell/de (&optional args)
  (dired (or args ".")))

(defun eshell/deo (&optional args)
  (dired-other-window (or args ".")))

(defun eshell/start (FILE)
  (os-start-file (expand-file-name FILE))
  nil)

(defun eshell/cdo ()
  "Change to cloud org file directory"
    (eshell/cd "~/Box/org"))

(defun eshell/etw ()
  "Edit work to do list"
    (find-file "~/Box/org/WorkTodo.org"))

(defun eshell/eotw ()
  "Edit work to do list in other window"
    (find-file-other-window "~/Box/org/WorkTodo.org"))

(defun eshell/etl ()
  "Edit life to do list"
    (find-file "~/Box/org/LifeTodo.org"))

(defun eshell/eotl ()
  "Edit life to do list in other window"
    (find-file-other-window "~/Box/org/LifeTodo.org"))

(defalias 'eshell/e 'find-file)
(defalias 'eshell/eo 'find-file-other-window)
(defalias 'eshell/he 'hexl-find-file)

(provide 'init-eshell)
