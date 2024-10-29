require("toggleterm").setup {
    open_mapping = [[<c-\>]],
	shell = vim.o.shell,
	start_in_insert = true,
    direction = "float",
}
