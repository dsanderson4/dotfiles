local M = {}

M.luasnip = require("luasnip")

M.expand_snippet = function(name)
  local snippets = M.luasnip.get_snippets(vim.bo.ft)
  local snippet = nil

  for _, v in ipairs(snippets) do
      if v.name == name then
          snippet = v
      end
  end
  if snippet ~= nil then
      M.luasnip.snip_expand(snippet)
  end
end

M.map_snippet = function(keys, name, description)
    vim.keymap.set("n", keys, function() M.expand_snippet(name) end, { silent = true, desc = description, buffer = 0})
end

return M
