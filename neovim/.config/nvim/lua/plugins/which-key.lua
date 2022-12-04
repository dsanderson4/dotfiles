local wk = require("which-key")
wk.setup {
    window = {
        border = "rounded",
        padding = {2, 2, 2, 2},
    }
}

wk.register({
    ["<leader>"] = {
        f = { name = "+Find" },
        j = { name = "+Jump" },
        l = { name = "+LSP" },
        t = { name = "+Terminal"},
        g = { name = "Git+" },
    }
})
