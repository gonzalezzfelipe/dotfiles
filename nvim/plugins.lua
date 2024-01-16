local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
  {
    "tmux-plugins/vim-tmux-focus-events",
    lazy = false
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "custom.nvimtree"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "pyright",
        "mypy",
        "black",
        "luaformatter",
      }
    }
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {
      "python",
    },
    opts = function()
      return require "custom.nullls"
    end
  },
  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require('pretty-fold').setup()
    end
  }
}

return plugins
