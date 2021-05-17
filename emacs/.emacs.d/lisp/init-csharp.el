(use-package csharp-mode
  :ensure t
  :init (add-hook 'csharp-mode-hook 'dsa/csharp-mode-hook)
  :mode "\\.cs")

(dsa/define-key
  :keymaps 'csharp-mode-map

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
  "sbc" '(snip-belgrade-class-revision :which-key "Class Revision")
  "sbm" '(snip-belgrade-method-revision :which-key "Method Revision")
  )

(defun dsa/csharp-mode-hook ()
  (lsp-deferred)
  (electric-pair-local-mode)
  (show-paren-mode)
  )

(add-to-list 'auto-mode-alist '("\\.xaml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.igr$" . nxml-mode))
 
(provide 'init-csharp)
