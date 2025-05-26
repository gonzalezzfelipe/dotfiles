local cmp = require "cmp"

local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "pyright",
        "mypy",
        "black",
        "luaformatter",
        "lua-language-server",
        "terraform-ls",
        "typescript-language-server",
        "prisma-language-server"
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
      require "nvchad.configs.lspconfig"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
  },
  {
    "saecki/crates.nvim",
    version = "^0.6.0",
    ft = { "toml" },
    config = function()
        require('crates').setup()
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "tpope/vim-surround",
    lazy = false
  },
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
      return require "nvchad.configs.nvimtree"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {
      "python",
    },
    opts = function()
      return require "nvchad.configs.nullls"
    end
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "codellama"
    },
    lazy = false
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      ensure_installed = {
        "lua",
        "json",
        "python",
        "toml",
        "yaml",
        "vim",
        "dockerfile",
        "graphql",
        "markdown",
        "query",
        "gitignore",
        "bash",
        "terraform"
      },
    }
  },
  {
    "ellisonleao/glow.nvim",
    ft = {
      "markdown"
    },
    config = true,
    cmd = "Glow"
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "cat /Users/felipe/.credentials/openapikey"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "bfontaine/Brewfile.vim",
    ft = {
      "Brewfile"
    }
  },
  {
    'prisma/vim-prisma',
    ft = {
      "prisma"
    }
  },
  {
    "findango/vim-mdx",
    ft = {
      "mdx"
    }
  },
  {
    "imsnif/kdl.vim",
    ft = {
      "kdl"
    }
  },
  {
      "hiasr/vim-zellij-navigator.nvim",
      config = function()
          require('vim-zellij-navigator').setup()
      end
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "Justfile" }
  }
}
return plugins
