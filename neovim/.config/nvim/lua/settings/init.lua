-- Settings init.lua

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

Util.mapKey("", "<Space>", "<Nop>")
vim.g.mapleader = ' '

Util.mapKey('i', 'jk', '<ESC>')
