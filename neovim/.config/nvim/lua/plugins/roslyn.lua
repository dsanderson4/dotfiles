 return {
  "seblj/roslyn.nvim",
  ft = "cs",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("roslyn").setup({
      -- If Mason installs the server, this may not be needed.
      -- If you installed Roslyn manually via easy-dotnet's checkhealth command,
      -- point this at the same binary:
      -- exe = "path/to/Microsoft.CodeAnalysis.LanguageServer",

      -- When multiple .sln files exist, search broadly and prompt to pick
      broad_search = true,

      -- Lock to a specific solution once chosen (persisted across sessions)
      lock_target = true,

      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "fullSolution",
          dotnet_compiler_diagnostics_scope = "fullSolution",
        },
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
  end,
}
