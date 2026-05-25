return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional but recommended
    },
    config = function()
      local dotnet = require("easy-dotnet")
      dotnet.setup({
        -- Override the SDK path if needed; nil = auto-detect
        -- sdk_path = "C:/Program Files/dotnet/dotnet.exe",
 
        lsp = { disabled = true},
        -- Terminal to use for run/test output
        terminal = function(path, action)
          local commands = {
            run    = "dotnet run",
            test   = "dotnet test",
            restore = "dotnet restore",
            build  = "dotnet build",
          }
          local cmd = commands[action]
          vim.cmd("botright 15sp | terminal " .. cmd)
        end,
 
        -- Auto-restore on opening a .sln/.csproj
        auto_restore = true,
      })
 
      -- Keymaps
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "dotnet: " .. desc })
      end
 
      map("<leader>dr", dotnet.run,     "run project")
      map("<leader>db", dotnet.build,   "build project")
      map("<leader>dt", dotnet.test,    "run tests")
      map("<leader>ds", dotnet.restore, "restore packages")
      map("<leader>dp", dotnet.secrets, "manage user-secrets")
      map("<leader>dS", dotnet.solution_select, "select solution")
 
      -- Pick and run a specific project (Telescope picker)
      map("<leader>dR", function()
        dotnet.run({ list = true })
      end, "pick & run project")
    end,

}
