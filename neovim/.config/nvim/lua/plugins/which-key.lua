return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
      spec = {
        { '<leader>f', group = '[F]ind' },
        { '<leader>j', group = '[J]ump' },
        { '<leader>l', group = '[L]SP' },
        { '<leader>t', group = '[T]erminal' },
        { '<leader>g', group = '[G]it' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>x', group = 'Misc' },
      },
  }
}
