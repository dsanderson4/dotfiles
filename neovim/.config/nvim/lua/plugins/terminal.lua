require("toggleterm").setup {
    open_mapping = "<c-\\>t",
	shell = vim.o.shell,
	start_in_insert = true,
    direction = "float",
}

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({cmd = "lazygit", hidden = true})
function _lazygit_toggle()
    lazygit:toggle()
end

vim.keymap.set("n", "<c-\\>g", "<cmd>lua _lazygit_toggle()<CR>", { silent = true })
