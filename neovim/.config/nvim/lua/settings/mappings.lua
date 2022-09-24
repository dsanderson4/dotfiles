vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

vim.keymap.set('i', 'jk', '<ESC>', { silent = true })

vim.keymap.set("n", "<leader>w",  "<cmd>w<cr>", { silent = true, desc ="Save" })
vim.keymap.set("n", "<leader>q",  "<cmd>q<cr>", { silent = true, desc ="Quit" })
vim.keymap.set("n", "<leader>h",  "<cmd>nohlsearch<cr>", { silent = true, desc ="No search highlights" })

vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end,
    { silent = true, desc = "Search files" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end,
    { silent = true, desc = "Search buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end,
    { silent = true, desc = "Search help" })
vim.keymap.set("n", "<leader>fm", function() require("telescope.builtin").marks() end,
    { silent = true, desc = "Search marks" })
vim.keymap.set("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end,
    { silent = true, desc = "Search history" })
vim.keymap.set("n", "<leader>fw", function() require("telescope.builtin").live_grep() end,
    { silent = true, desc = "Search words" })

vim.keymap.set("n", "<leader>lG", function() require("telescope.builtin").lsp_workspace_symbols() end,
    { silent = true, desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>lR", function() require("telescope.builtin").lsp_references() end,
    { silent = true, desc = "References" })
vim.keymap.set("n", "<leader>lD", function() require("telescope.builtin").diagnostics() end,
    { silent = true, desc = "Diagnostics" })

vim.keymap.set("n", "<leader>lI",  "<cmd>Mason<cr>", { silent = true, desc ="LSP installer" })
vim.keymap.set("n", "<leader>li",  "<cmd>LspInfo<cr>", { silent = true, desc ="LSP information" })

vim.keymap.set("n", "<leader>jl", "<cmd>HopLine<CR>", { silent = true, desc = "Line" })
vim.keymap.set("n", "<leader>jw", "<cmd>HopWord<CR>", { silent = true, desc = "Word" })
vim.keymap.set("n", "<leader>jc", "<cmd>HopChar1<CR>", { silent = true, desc = "Character" })
vim.keymap.set("n", "<leader>jC", "<cmd>HopChar2<CR>", { silent = true, desc = "Bigram" })
vim.keymap.set("n", "<leader>jp", "<cmd>HopPattern<CR>", { silent = true, desc = "Pattern" })

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Tree"})
vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { silent = true, desc = "Focus File Tree"})
