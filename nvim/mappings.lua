local M = {}

M.abc = {
  n = {
    -- Telescope
    ["<C-p>"] = { "<cmd>Telescope find_files<cr>", "Telescope" },
    ["<C-g>"] = { "<cmd>Telescope live_grep<cr>" },

    -- Tree
    ["<C-o>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- Tabs
    ["t"] = { "tabnew<enter>" },
    ["<C-h>"] = { "<cmd>TmuxNavigateLeft<cr>" },
    ["<C-j>"] = { "<cmd>TmuxNavigateDown<cr>" },
    ["<C-k>"] = { "<cmd>TmuxNavigateUp<cr>" },
    ["<C-l>"] = { "<cmd>TmuxNavigateRight<cr>" },
    ["<C-\\>"] ={ "<cmd>TmuxNavigatePrevious<cr>" },

    -- Create and destroy panes
    ["S"] = { ":w<enter>" },
    ["s"] = { ":split<enter>" },
    ["V"] = { ":vsplit<enter>" },
    ["x"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    ["X"] = { ":q!<enter>" },
    -- Undo and redo
    ["<S-u>"] = { "<C-R>" },
    ["<C-s>"] = { ":w<enter>" },

    -- Delete, don't cut
    ["d"] = { "\"_d" },

    -- Folding
    [" "] = { "za" }
  },

  v = {
    -- Delete, don't cut
    ["d"] = { "\"_d" },
    ["p"] = { "\"_dP" },
  },
}

return M
