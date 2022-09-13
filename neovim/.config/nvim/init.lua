local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'phha/zenburn.nvim'
  use 'numToStr/Comment.nvim'
  use 'phaazon/hop.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'

  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  use 'windwp/nvim-autopairs'
  use 'nvim-telescope/telescope.nvim'
  use 'akinsho/toggleterm.nvim'

  if is_bootstrap then
    require('packer').sync()
  end
end)

vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 0
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.autochdir = true
vim.opt.mouse = "a"

-- if vim.loop.os_uname().sysname == "Windows_NT" then
--     vim.opt.shell = "powershell"
-- end

local keymap = vim.keymap.set
local opts = { silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '

keymap('i', 'jk', '<ESC>')

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline',
    component_separators = '|',
    section_separators = '',
  },
}

require('hop').setup {
    keys = 'etovxqpdygfblzhckisuran'
}

keymap("n", "<leader>jl", "<cmd>HopLine<CR>", opts)
keymap("n", "<leader>jw", "<cmd>HopWord<CR>", opts)
keymap("n", "<leader>jc", "<cmd>HopChar1<CR>", opts)
keymap("n", "<leader>jC", "<cmd>HopChar2<CR>", opts)
keymap("n", "<leader>jp", "<cmd>HopPattern<CR>", opts)

require('nvim-tree').setup {
    disable_netrw = true,
    hijack_netrw = true,
    view = {
      number = true,
      relativenumber = true,
    },
    filters = {
      custom = { ".git" },
    },
}
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)

require "user.completion"

require "user.telescope"
keymap("n", "<leader>tf", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>tb", "<cmd>Telescope buffers<CR>", opts)

require("user.terminal")
keymap("n", "<c-\\>g", "<cmd>lua _lazygit_toggle()<CR>", opts)

require('nvim-autopairs').setup()

require('zenburn').setup()

require('Comment').setup()
