(defun dsa/eglot-config ()
  (cond
   ((eq system-type 'windows-nt)
    (add-to-list 'eglot-server-programs
                 `(csharp-tree-sitter-mode . ("c:/ProgramData/chocolatey/lib/omnisharp/tools/OmniSharp.exe"
                                              "-lsp"))))
   ((eq system-type 'gnu/linux)
    (add-to-list 'eglot-server-programs
                 `(csharp-tree-sitter-mode . ("/usr/bin/omnisharp" "-lsp"))))))

(if (< emacs-major-version 29)
    (use-package eglot
      :config
      (dsa/eglot-config))
  (use-package eglot
    :ensure nil
    :config
    (dsa/eglot-config)))

(dsa/define-key
  :keymaps 'eglot-mode-map

  "g" '(:ignore t :which-key "Go")
  "gt" '(xref-find-apropos :which-key "Symbol")
  "gd" '(xref-find-definitions :which-key "Definition")
  "gD" '(xref-find-definitions-other-window :which-key "Definition Other Window")
  "gm" '(counsel-imenu :which-key "File Member")

  "f" '(:ignore t :which-key "Find")
  "fu" '(xref-find-references :which-key "Usages")
  "fi" '(eglot-find-implementation :which-key "Implementations"))

(provide 'init-eglot)
