local plugins = {
  -- Shared plugins (work in both VS Code and Neovim)
  require 'plugins/comment',
  require 'plugins/hop',
  require 'plugins/surround',
  require 'plugins/bufdelete',
}

if not vim.g.vscode then
  vim.list_extend(plugins, {
    require 'plugins/which-key',
    require 'plugins/tree',
    require 'plugins/telescope',
    require 'plugins/lspconfig',
    require 'plugins/winpick',
    require 'plugins/bufexplorer',
    require 'plugins/completion',
    require 'plugins/onedarkpro',
    require 'plugins/lualine',
    require 'plugins/vim-fugitive',
    require 'plugins/vim-gitgutter',
    require 'plugins/indent-blankline',
    require 'plugins/aerial',
    require 'plugins/autopairs',
    require 'plugins/terminal',
    require 'plugins/treesitter',
  })
end

require('lazy').setup(plugins, {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
      }
})

-- vim: ts=2 sts=2 sw=2 et
