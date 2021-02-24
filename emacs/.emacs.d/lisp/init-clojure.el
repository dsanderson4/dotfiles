(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)))

(add-hook 'clojure-mode-hook
          '(lambda ()
             (lsp) 
             (when (eq system-type 'windows-nt)
               (setq lsp-clojure-custom-server-command
                     (list "cmd" "/c" (lsp-clojure--server-executable-path))))
             (dsa/lisp-hook)))

(use-package cider
  :defer t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
        cider-repl-display-in-current-window nil
        cider-repl-use-clojure-font-lock t    
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        nrepl-hide-special-buffers t            
        cider-overlays-use-font-lock t)         
  (cider-repl-toggle-pretty-printing))

(add-hook 'cider-repl-mode-hook
          '(lambda ()
             (company-mode)
             (dsa/lisp-hook)))

(provide 'init-clojure)
