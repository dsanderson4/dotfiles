local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

treesitter.setup({
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
})

if vim.loop.os_uname().sysname == "Windows_NT" then
<<<<<<< HEAD
    require 'nvim-treesitter.install'.compilers = {"cl", "clang", "gcc"}
=======
    require 'nvim-treesitter.install'.compilers = {"cl", "gcc"}
>>>>>>> 7c37ef75a43181bc33fb15185c13c14d02d2dd87
end
