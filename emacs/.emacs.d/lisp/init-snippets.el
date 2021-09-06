(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(defun my-compile-markdown ()
  (interactive)
  (let*
      ((input-name (file-name-nondirectory buffer-file-name))
       (output-name (concat (file-name-sans-extension input-name) ".html")))
    (save-buffer)
    (shell-command (concat "pandoc -s " input-name " -o " output-name))
    (w32-shell-execute "Open" (expand-file-name output-name))))

(defun force-insert-mode ()
  (when (fboundp 'evil-insert)
    (evil-insert 1)))

(defun snip-markdown-header ()
  (interactive)
  (insert-yas-snippet "Header"))

(defun snip-jira-link ()
  (interactive)
  (yas-expand-snippet (yas-lookup-snippet "Jira Link")))

(defun snip-file-revision ()
  (interactive)
  (let ((rev-date (format-time-string "%m/%d/%y"))
        (comment "File modified."))
    (goto-char (point-min))
    (forward-line 1)
    (search-forward "------------")
    (forward-line 0)
    (yas-expand-snippet (yas-lookup-snippet "File Modified"))))

(defun snip-class-revision ()
  (interactive)
  (insert-yas-snippet "Class Revision"))

(defun snip-method-revision ()
  (interactive)
  (insert-yas-snippet "Method Revision"))

(defun snip-file-header ()
  (interactive)
  (insert-yas-snippet "File Header"))

(defun snip-class-header ()
  (interactive)
  (insert-yas-snippet "Class Header"))

(defun snip-enum-header ()
  (interactive)
  (insert-yas-snippet "Enum Header"))

(defun snip-method-header ()
  (interactive)
  (insert-yas-snippet "Method Header"))

(defun snip-property-header ()
  (interactive)
  (insert-yas-snippet "Property Header"))

(defun snip-property-body ()
  (interactive)
  (insert-yas-snippet "Property Body"))

(defun snip-method-param1 ()
  (interactive)
  (insert-yas-snippet "Method Parameter"))

(defun snip-type-param ()
  (interactive)
  (insert-yas-snippet "Type Parameter"))

(defun snip-method-return ()
  (interactive)
  (insert-yas-snippet "Method Return"))

(defun snip-method-tag()
  (interactive)
  (insert-yas-snippet "Method Tag"))

(defun snip-external-unit ()
  (interactive)
  (insert-yas-snippet "External Unit"))

(defun snip-belgrade-call ()
  (interactive)
  (insert-yas-snippet "Belgrade Call"))

(defun snip-summary ()
  (interactive)
  (insert-yas-snippet "Summary"))

(defun snip-value()
  (interactive)
  (insert-yas-snippet "Property Value"))

(defun snip-construct ()
  (interactive)
  (force-insert-mode)
  (yas-expand-snippet (yas-lookup-snippet "Construct")))

(defun snip-exception ()
  (interactive)
  (insert-yas-snippet "Exception"))

(defun snip-gw ()
  (interactive)
  (insert "Gets a value indicating whether "))

(defun snip-sw ()
  (interactive)
  (insert "Sets a value indicating whether "))

(defun snip-gsw ()
  (interactive)
  (insert "Gets or sets a value indicating whether "))

(defun snip-belgrade-file-header ()
  (interactive)
  (insert-yas-snippet "Belgrade File Header"))

(defun snip-belgrade-method-revision ()
  (interactive)
  (insert-yas-snippet "Belgrade Method Revision"))

(defun snip-belgrade-class-revision ()
  (interactive)
  (insert-yas-snippet "Belgrade Class Revision"))

(defun snip-belgrade-class-header()
  (interactive)
  (insert-yas-snippet "Belgrade Class Header"))

(defun snip-belgrade-method-header()
  (interactive)
  (insert-yas-snippet "Belgrade Method Header"))

(defun snip-belgrade-property-header()
  (interactive)
  (insert-yas-snippet "Belgrade Property Header"))

(defun insert-yas-snippet (name)
  (beginning-of-line)
  (force-insert-mode)
  (yas-expand-snippet (yas-lookup-snippet name)))

(provide 'init-snippets)
