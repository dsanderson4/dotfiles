return {
    {
       "nvim-treesitter/nvim-treesitter",
       run = ":TSUpdate",
       event = { "BufRead", "BufNewFile" },
       cmd = {
         "TSInstall",
         "TSInstallInfo",
         "TSInstallSync",
         "TSUninstall",
         "TSUpdate",
         "TSUpdateSync",
         "TSDisableAll",
         "TSEnableAll",
       },
       opts = {
           ensure_installed = {},
           sync_install = false,
           ignore_install = {},
           highlight = {
             enable = true,
             additional_vim_regex_highlighting = false,
           },
           context_commentstring = {
             enable = true,
             enable_autocmd = false,
           },
           rainbow = {
             enable = true,
             disable = { "html" },
             extended_mode = false,
             max_file_lines = nil,
           },
           autopairs = { enable = true },
           autotag = { enable = true },
           incremental_selection = { enable = true },
           indent = { enable = false },
       },
       config = function()
            if vim.loop.os_uname().sysname == "Windows_NT" then
                require 'nvim-treesitter.install'.compilers = {"cl", "clang", "gcc"}
            end
       end
    },
}
