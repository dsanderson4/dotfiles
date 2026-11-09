vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

require 'settings.settings'
require 'lazy.bootstrap'
require 'lazy.plugins'
require 'settings.mappings'

pcall(vim.fn.serverstart, [[\\.\pipe\nvim-server]])
