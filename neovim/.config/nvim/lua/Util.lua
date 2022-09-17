-- util.lua

_G.Util = {}

Util.mapKey = function(mode, key, action)
    vim.keymap.set(mode, key, action, { silent = true })
end
