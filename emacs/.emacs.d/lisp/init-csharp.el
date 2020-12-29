(use-package csharp-mode
  :init (add-hook 'csharp-mode-hook 'my-csharp-mode-setup)
  :mode "\\.cs")

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (flycheck-mode))

(use-package omnisharp
  :after csharp-mode
  :preface
    (defun my/configure-omnisharp ()
      (omnisharp-mode)
      (add-to-list 'company-backends #'company-omnisharp)
      (company-mode)
      (dsa/define-key
       :keymaps 'omnisharp-mode-map
       "gd" '(omnisharp-go-to-definition :which-key "Definition")
       "gD" '(omnisharp-go-to-definition-other-window :which-key "Definition, Other Window")
       "gm" '(omnisharp-navigate-to-current-file-member :which-key "File Member")
       "gr" '(omnisharp-run-code-action-refactoring :which-key "Refactoring")

       "f" '(:ignore t :which-key "Omnisharp Find")
       "fu" '(omnisharp-find-usages :which-key "Usages")
       "fi" '(omnisharp-find-implementations :which-key "Implementations")

       "s" '(:ignore t :which-key "C# Snippets")
       "se" '(snip-exception :which-key "Exception")
       "sp" '(snip-property-header :which-key "Property Header")
       "ss" '(snip-summary :which-key "Summary")
       "su" '(snip-external-unit :which-key "External Unit")
       "sx" '(format-xml-comment :which-key "Format XML Comment")
       "sv" '(snip-value :which-key "Value")

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
       ))
  :init
  (add-hook 'csharp-mode-hook #'my/configure-omnisharp)
  )

(add-to-list 'auto-mode-alist '("\\.xaml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.igr$" . nxml-mode))
 
(provide 'init-csharp)
