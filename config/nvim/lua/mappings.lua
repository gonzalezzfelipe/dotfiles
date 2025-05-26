require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<cr>")
map("n", "<C-g>", "<cmd>Telescope live_grep<cr>")

-- Tree
map("n", "<C-o>", "<cmd> NvimTreeToggle <CR>")

-- Tabs
map("n", "t", "tabnew<enter>")
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")

-- Create and destroy panes
map("n", "S", ":w<enter>")
map("n", "s", ":split<enter>")
map("n", "V", ":vsplit<enter>")
map("n", "x",
  function()
  require("nvchad.tabufline").close_buffer()
  end
)
map("n", "X", ":q!<enter>")

-- Undo and redo
map("n", "<S-u>", "<C-R>")
map("n", "<C-s>", ":w<enter>")

-- Delete, don't cut
map("n", "d", "\"_d")
map("v", "d", "\"_d")
map("v", "p", "\"_dP")

-- Folding
map("n", " ", "za")

-- Code actions
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action() <enter>")
