vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

require 'settings.settings'
require 'lazy.bootstrap'
require 'lazy.plugins'
require 'settings.mappings'

vim.fn.serverstart([[\\.\pipe\nvim-server]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
