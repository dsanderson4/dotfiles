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
