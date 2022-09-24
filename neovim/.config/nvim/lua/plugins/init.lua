-- Plugins/init.lua
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"

  use {
      "nvim-lualine/lualine.nvim",
      config = function()
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'powerline',
            component_separators = '|',
            section_separators = '',
          }
        }
      end
  }

  use {
      "phha/zenburn.nvim",
      config = function()
        require('zenburn').setup()
      end
  }

  use {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup()
      end
  }

  use {
      "phaazon/hop.nvim",
      config = function()
        require("hop").setup {
            keys = "etovxqpdygfblzhckisuran"
        }
      end
  }

  use {
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
          require('nvim-tree').setup {
              disable_netrw = true,
              hijack_netrw = true,
              view = {
                number = true,
                relativenumber = true,
              },
              filters = {
                custom = { ".git" },
              },
          }
      end
  }

  use {
      "williamboman/mason.nvim",
      config = function()
          require("mason").setup()
      end
  }

  use {
      "neovim/nvim-lspconfig",
      config = function()
          require "plugins.lspconfig"
      end
  }

  use {
      "williamboman/mason-lspconfig.nvim",
      after = { "mason.nvim", "nvim-lspconfig" },
      config = function()
          require("mason-lspconfig").setup()
      end
  }

  use {
      "hrsh7th/nvim-cmp",
      config = function()
          require "plugins.completion"
      end
  }

  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "saadparwaiz1/cmp_luasnip"

  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  use {
      "folke/which-key.nvim",
      config = function()
          require "plugins.which-key"
      end
  }

  use {
      "windwp/nvim-autopairs",
      config = function()
          require("nvim-autopairs").setup()
      end
  }

  use {
      "nvim-telescope/telescope.nvim",
      config = function()
          require "plugins.telescope"
      end
  }

  use {
      "akinsho/toggleterm.nvim",
      config = function()
          require "plugins.terminal"
      end
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)
