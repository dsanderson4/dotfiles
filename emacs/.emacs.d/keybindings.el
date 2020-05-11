(global-set-key [C-tab] 'bs-cycle-next)
(global-set-key "\C-o" 'other-window)
(global-set-key [?\C-%] 'shrink-window)
(global-set-key [?\C-^] 'enlarge-window)
(global-set-key [?\C-&] 'shrink-window-horizontally)
(global-set-key [?\C-*] 'enlarge-window-horizontally)

(global-set-key [M-backspace] 'advertised-undo)
(global-set-key "\M-]" 'scroll-up-1)
(global-set-key "\M-[" 'scroll-down-1)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-o" 'find-file)
(global-set-key "\C-x\C-b" 'bs-show)

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

(global-set-key "\C-czfh" 'snip-file-header)
(global-set-key "\C-czfr" 'snip-file-revision)

(global-set-key "\C-czfx" 'format-xml-comment)

(global-set-key "\C-czch" 'snip-class-header)
(global-set-key "\C-czcr" 'snip-class-revision)

(global-set-key "\C-czeu" 'snip-external-unit)

(global-set-key "\C-czmr" 'snip-method-revision)
(global-set-key "\C-czmh" 'snip-method-header)

(global-set-key "\C-czph" 'snip-property-header)

(global-set-key "\C-czs" 'snip-summary)
