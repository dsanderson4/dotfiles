(use-package tree-sitter)
(use-package tree-sitter-indent)
(use-package tree-sitter-langs)

(use-package csharp-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode))
  (add-hook 'csharp-tree-sitter-mode-hook 'dsa/csharp-mode-hook)
  (add-hook 'csharp-tree-sitter-mode-hook (lambda () (yas-activate-extra-mode 'csharp-mode))))

(dsa/define-key
  :keymaps '(csharp-mode-map csharp-tree-sitter-mode-map)

  "s" '(:ignore t :which-key "C# Snippets")
  "se" '(snip-exception :which-key "Exception")
  "so" '(open-xml-comment :which-key "Open XML Comment")
  "sp" '(snip-property-header :which-key "Property Header")
  "ss" '(snip-summary :which-key "Summary")
  "su" '(snip-external-unit :which-key "External Unit")
  "sx" '(format-xml-comment :which-key "Format XML Comment")
  "sv" '(snip-value :which-key "Value")
  "sw" '(snip-gsw :which-key "Gets or Sets Whether...")

  "sf" '(:ignore t :which-key "File")
  "sfh" '(snip-file-header :which-key "File Header")
  "sfr" '(snip-file-revision :which-key "File Revision")

  "sc" '(:ignore t :which-key "Class")
  "sch" '(snip-class-header :which-key "Class Header")
  "scr" '(snip-class-revision :which-key "Class Revision")
  "sco" '(snip-construct :which-key "Constructor")

  "sm" '(:ignore t :which-key "Method")
  "smh" '(snip-method-header :which-key "Header")
  "smr" '(snip-method-revision :which-key "Revision")
  "smp" '(snip-method-param1 :which-key "Parameter")
  "smt" '(snip-method-return :which-key "Return")
  "smg" '(snip-method-tag :which-key "Tag")

  "sb" '(:ignore t :which-key "Belgrade")
  "sbf" '(snip-belgrade-file-header :which-key "File Header")
  "sbl" '(snip-belgrade-class-header :which-key "Class Header")
  "sbc" '(snip-belgrade-class-revision :which-key "Class Revision")
  "sbm" '(snip-belgrade-method-revision :which-key "Method Revision")
  "sbh" '(snip-belgrade-method-header :which-key "Method Header")
  "sbp" '(snip-belgrade-property-header :which-key "Property Header")
  "sbu" '(snip-belgrade-call :which-key "Call Sequence Unit")

  "st" '(:ignore t :which-key "StyleCop")
  "stf" '(style-cop-file :which-key "Current File")
  "std" '(style-cop-folder :which-key "Directory")
  "stn" '(style-cop-next-violation :which-key "Next Violation")
  "stj" '(style-cop-next-violation :which-key "Next Violation")
  "stp" '(style-cop-previous-violation :which-key "Previous Violation")
  "stk" '(style-cop-previous-violation :which-key "Previous Violation")
  )

(defcustom style-cop-batch-path "c:/StyleCop"
  "The directory containing StyleCop batch and project files."
  :type 'string
  :group 'StyleCop)

(defun style-cop-process-ouptut ()
  (switch-to-buffer-other-window "*StyleCop*")
  (keep-lines "SA[0-9]+:\\|^  Succeeded:\\|^  Adding file:")
  (replace-regexp " - Failed on Line " ":")
  (beginning-of-buffer)
  (search-forward "Succeeded:")
  (backward-word)
  (evil-next-line))

(defun style-cop-file ()
  (interactive)
  (shell-command (format "%s/StyleCopFile.bat \"%s\"" style-cop-batch-path (buffer-file-name)) "*StyleCop*")
  (style-cop-process-ouptut))

(defun style-cop-folder(folder)
  (interactive "D")
  (shell-command
   (format "%s/StyleCopFolder.bat \"%s\"" style-cop-batch-path (substring (subst-char-in-string ?/ ?\\ folder) 0 -1))
   "*StyleCop*")
  (style-cop-process-ouptut))

(defun style-cop-go-to-violation ()
  (interactive)
  (let ((position (point)) error-position error-message)
    (search-forward-regexp "SA[0-9]+: ")
    (backward-word)
    (setq error-position (point))
    (end-of-line)
    (setq error-message (buffer-substring error-position (point)))
    (goto-char position)
    (evil-find-file-at-point-with-line)
    (evil-window-rotate-downwards)
    (message error-message)
    (switch-to-buffer "*StyleCop*")
    (goto-char position)
    (other-window 1)))

(defun style-cop-next-violation ()
  (interactive)
  (switch-to-buffer-other-window "*StyleCop*")
  (evil-next-line)
  (style-cop-go-to-violation))

(defun style-cop-previous-violation ()
  (interactive)
  (switch-to-buffer-other-window "*StyleCop*")
  (evil-previous-line)
  (style-cop-go-to-violation))

(define-key evil-normal-state-map "gp" 'style-cop-go-to-violation)

(defun dsa/csharp-mode-hook ()
  (lsp-deferred)
  (electric-pair-local-mode)
  (show-paren-mode))

(add-to-list 'auto-mode-alist '("\\.xaml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.igr$" . nxml-mode))
 
(provide 'init-csharp)
