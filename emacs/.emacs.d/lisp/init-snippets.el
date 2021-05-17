(setq snip-text-file-revision
      "// <revision revisor=\"dave.anderson\" date=\"%s\">
//     %s
// </revision>\n")

(setq snip-text-class-revision
      "    /// <revision revisor=\"dave.anderson\" date=\"%s\">
    ///     $.
    /// </revision>\n")

(setq snip-text-method-revision
      "        /// <revision revisor=\"dave.anderson\" date=\"%s\">
        ///     $.
        /// </revision>\n")

(setq snip-text-file-header
      "// -----------------------------------------------------------------------------
// <copyright file=\"$${itemname}.cs\" company=\"Dominion Voting Systems\">
//     Copyright (c) $${year} Dominion Voting Systems, Inc. All Rights Reserved.
//     Any distribution of source code by others is prohibited.
// </copyright>
// <summary>
//     $.
// </summary>
// <revision revisor=\"dave.anderson\" date=\"%s\">
//     File Created.
// </revision>
// -----------------------------------------------------------------------------\n")

(setq snip-text-class-header
    "    /// <summary>
    ///     $.
    /// </summary>
    /// <revision revisor=\"dave.anderson\" date=\"%s\">
    ///     Class created.
    /// </revision>\n")

(setq snip-text-enum-header
    "    /// <summary>
    ///     $.
    /// </summary>
    /// <revision revisor=\"dave.anderson\" date=\"%s\">
    ///     Created.
    /// </revision>\n")

(setq snip-text-method-header
    "        /// <summary>
        ///     $.
        /// </summary>
        /// <revision revisor=\"dave.anderson\" date=\"%s\">
        ///     Method created.
        /// </revision>\n")

(setq snip-text-property-header
    "        /// <summary>
        ///     $.
        /// </summary>
        /// <revision revisor=\"dave.anderson\" date=\"%s\">
        ///     Property created.
        /// </revision>\n")

(setq snip-text-property-body
      "        public $${type} $${property}
        {
            get
            {
                return this.$${field};
            }
            set
            {
                this.$${field} = value;
            }
        }\n\n")


(setq snip-text-method-param1
  "        /// <param name=\"$${name}\">$.</param>\n")

(setq snip-text-type-param
  "        /// <typeparam name=\"$${name}\">$.</typeparam>\n")

(setq snip-text-method-return
      "        /// <returns>$.</returns>\n")

(setq snip-text-method-tag
      "        /// <$${name}>
        /// </$${name}>\n")

(setq snip-text-external-unit
      "        /// <externalUnit cref=\"$.\" />\n")

(setq snip-text-summary
      "        /// <summary>$.</summary>\n")

(setq snip-text-value
      "        /// <value>$.</value>\n")

(setq snip-text-file
      "        /// <file>$.</file>\n")

(setq snip-text-region
      "\n        #region $.\n\n        #endregion\n")

(setq snip-text-construct
      "Initializes a new instance of the <see cref=\"$.\"/> class.")

(setq snip-text-exception
    "        /// <exception cref=\"$${name}\">
        ///     $.
        /// </exception>\n")

(setq snip-text-markdown-header
      "---
title: $.
...")

(setq snip-text-jira-link
      "[$${project}-$${number}](http://jirabg.dominionvoting.com/browse/$${project}-$${number})")

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
  (force-insert-mode)
  (snippet-insert snip-text-markdown-header))

(defun snip-jira-link ()
  (interactive)
  (snippet-insert snip-text-jira-link))

(defun snip-file-revision ()
  (interactive)
  (let ((rev-date (format-time-string "%m/%d/%y"))
        (comment "File modified."))
    (goto-char (point-min))
    (forward-line 1)
    (search-forward "------------")
    (forward-line 0)
    (insert (format snip-text-file-revision rev-date comment))
    )
  )

(defun snip-class-revision ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-class-revision))

(defun snip-method-revision ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-method-revision))

(defun snip-file-header ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-file-header))

(defun snip-class-header ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-class-header))

(defun snip-enum-header ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-enum-header))

(defun snip-method-header ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-method-header))

(defun snip-property-header ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snip-date snip-text-property-header))

(defun snip-property-body ()
  (interactive)
  (snippet-insert snip-text-property-body))

(defun snip-method-param1 ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-method-param1))

(defun snip-type-param ()
  (interactive)
  (force-insert-mode)
  (snippet-insert snip-text-type-param))

(defun snip-method-return ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-method-return))

(defun snip-method-tag()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-method-tag))

(defun snip-external-unit ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-external-unit))

(defun snip-summary ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-summary))

(defun snip-value ()
  (interactive)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert snip-text-value))

(defun snip-file ()
  (interactive)
  (snippet-insert snip-text-file))

(defun snip-region ()
  (interactive)
  (snippet-insert snip-text-region))

(defun snip-construct ()
  (interactive)
  (force-insert-mode)
  (snippet-insert snip-text-construct))

(defun snip-exception ()
  (interactive)
  (force-insert-mode)
  (snippet-insert snip-text-exception))

(defun snip-gw ()
  (interactive)
  (insert "Gets a value indicating whether "))

(defun snip-sw ()
  (interactive)
  (insert "Sets a value indicating whether "))

(defun snip-gsw ()
  (interactive)
  (insert "Gets or sets a value indicating whether "))

(setq snip-text-belgrade-revision
      "%s/// $. - %s - dave.anderson #$\n")

(defun snip-belgrade-method-revision ()
  (interactive)
  (snip-belgrade-revision "        "))

(defun snip-belgrade-class-revision ()
  (interactive)
  (snip-belgrade-revision "    "))

(defun snip-belgrade-revision (leading-spaces)
  (beginning-of-line)
  (force-insert-mode)
  (snippet-insert (format snip-text-belgrade-revision leading-spaces (format-time-string "%m/%d/%Y %R %p"))))

(defun snip-date (text)
  (let ((rev-date (format-time-string "%m/%d/%y")))
    (snippet-insert (format text rev-date))
    )
  )

(provide 'init-snippets)
