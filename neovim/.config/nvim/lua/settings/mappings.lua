vim.keymap.set('i', 'jk', '<ESC>', { silent = true })

vim.keymap.set("n", "<leader>h",  "<cmd>nohlsearch<cr>", { silent = true, desc ="No search highlights" })

vim.keymap.set("n", "<leader>bq",  "<cmd>q<cr>", { silent = true, desc ="Quit" })
vim.keymap.set("n", "<leader>bk",  "<cmd>Bdelete<cr>", { silent = true, desc ="Close" })
vim.keymap.set("n", "<leader>bl",  "<cmd>BufExplorer<cr>", { silent = true, desc ="Explore" })

vim.keymap.set("n", "<leader>xs",  "<cmd>w<cr>", { silent = true, desc ="Save" })
vim.keymap.set("n", "<leader>xS",  "<cmd>wa<cr>", { silent = true, desc ="Save all" })
vim.keymap.set("n", "<leader>xc",  "<cmd>qa<cr>", { silent = true, desc ="Quit" })

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
vim.keymap.set("n", "<C-s>", function() require("telescope.builtin").current_buffer_fuzzy_find() end,
    { silent = true, desc = "Search words" })

vim.keymap.set("n", "<leader>lG", function() require("telescope.builtin").lsp_workspace_symbols() end,
    { silent = true, desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>lR", function() require("telescope.builtin").lsp_references() end,
    { silent = true, desc = "References" })
vim.keymap.set("n", "<leader>lD", function() require("telescope.builtin").diagnostics() end,
    { silent = true, desc = "Diagnostics" })

vim.keymap.set("n", "<leader>lI",  "<cmd>Mason<cr>", { silent = true, desc ="LSP installer" })
vim.keymap.set("n", "<leader>li",  "<cmd>LspInfo<cr>", { silent = true, desc ="LSP information" })
vim.keymap.set("n", "<leader>lS",  "<cmd>AerialToggle<cr>", { silent = true, desc ="Symbols outline" })

vim.keymap.set("n", "<leader>jl", "<cmd>HopLine<CR>", { silent = true, desc = "Line" })
vim.keymap.set("n", "<leader>jw", "<cmd>HopWord<CR>", { silent = true, desc = "Word" })
vim.keymap.set("n", "<leader>jc", "<cmd>HopChar1<CR>", { silent = true, desc = "Character" })
vim.keymap.set("n", "<leader>jC", "<cmd>HopChar2<CR>", { silent = true, desc = "Bigram" })
vim.keymap.set("n", "<leader>jp", "<cmd>HopPattern<CR>", { silent = true, desc = "Pattern" })

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Tree"})
vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { silent = true, desc = "Focus File Tree"})

vim.keymap.set("n", "<leader>lG", function() require("telescope.builtin").lsp_workspace_symbols() end,
    { silent = true, desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>lR", function() require("telescope.builtin").lsp_references() end,
    { silent = true, desc = "References" })
vim.keymap.set("n", "<leader>lD", function() require("telescope.builtin").diagnostics() end,
    { silent = true, desc = "Diagnostics" })

vim.keymap.set("n", "<leader>gv", "<cmd>vertical Git<CR>", { silent = true, desc = "Vertical menu" })
vim.keymap.set("n", "<leader>gm", "<cmd>Git<CR>", { silent = true, desc = "Menu" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { silent = true, desc = "Menu" })

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Tree"})
vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { silent = true, desc = "Focus File Tree"})

vim.keymap.set("n", "<C-w>p", function()
    local winid = require("winpick").select()
    if winid then
        vim.api.nvim_set_current_win(winid)
    end
end, {silent = true, desc = "Pick a window"})

UserTerminals = {}

ToggleTerminalCommand = function(command)
    local details = { cmd = command, hidden = true }
    local key = command

    if vim.v.count > 0 and details.count == nil then
        details.count = vim.v.count
        key = key .. vim.v.count
    end

    if UserTerminals[key] == nil then
        UserTerminals[key] = require("toggleterm.terminal").Terminal:new(details)
    end

    UserTerminals[key]:toggle()
end

vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm<cr>",  { silent = true, desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tn", function() ToggleTerminalCommand "node" end,  { silent = true, desc = "Toggle terminal node" })
vim.keymap.set("n", "<leader>tg", function() ToggleTerminalCommand "lazygit" end,
    { silent = true, desc = "Toggle terminal lazygit" })
vim.keymap.set("n", "<leader>tp", function() ToggleTerminalCommand "python" end,
    { silent = true, desc = "Toggle terminal python" })
vim.keymap.set("n", "<leader>to", function() ToggleTerminalCommand "powershell" end,
    { silent = true, desc = "Toggle terminal powershell" })

vim.keymap.set("t", "<esc",  "<C-\\><C-n>", { silent = true, desc = "Terminal normal mode" })
vim.keymap.set("t", "jk",  "<C-\\><C-n>", { silent = true, desc = "Terminal normal mode" })
vim.keymap.set("t", "<C-h>",  "<C-\\><C-n><C-W>h", { silent = true, desc = "Terminal left window navigation" })
vim.keymap.set("t", "<C-j>",  "<C-\\><C-n><C-W>j", { silent = true, desc = "Terminal down window navigation" })
vim.keymap.set("t", "<C-k>",  "<C-\\><C-n><C-W>k", { silent = true, desc = "Terminal up window navigation" })
vim.keymap.set("t", "<C-l>",  "<C-\\><C-n><C-W>l", { silent = true, desc = "Terminal right window navigation" })
