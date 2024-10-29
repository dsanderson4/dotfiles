local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float,
      { noremap=true, silent=true, buffer=bufnr, desc = "Hover diagnostics" })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
      { noremap=true, silent=true, buffer=bufnr, desc = "Previous diagnostic" })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
      { noremap=true, silent=true, buffer=bufnr, desc="Next diagnostic" })

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
    { noremap=true, silent=true, buffer=bufnr, desc="Declaration of current symbol" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
    { noremap=true, silent=true, buffer=bufnr, desc="Definition of current symbol" })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover,
    { noremap=true, silent=true, buffer=bufnr, desc="Hover symbol details" })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
    { noremap=true, silent=true, buffer=bufnr, desc="Implementation of current symbol" })
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help,
    { noremap=true, silent=true, buffer=bufnr, desc="Signature help" })
  -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition,
    { noremap=true, silent=true, buffer=bufnr, desc="Definition of current type" })
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename,
    { noremap=true, silent=true, buffer=bufnr, desc="Rename current symbol" })
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action,
    { noremap=true, silent=true, buffer=bufnr, desc="LSP code action" })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,
    { noremap=true, silent=true, buffer=bufnr, desc="References of current symbol" })
  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting,
    { noremap=true, silent=true, buffer=bufnr, desc="Format code" })
end

require'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.pyright.setup{
    on_attach = on_attach
}

require'lspconfig'.omnisharp.setup {
    on_attach = on_attach,
    cmd = {"dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp.dll" },
    -- root_dir = require"lspconfig/util".root_pattern("*.sln")
}
