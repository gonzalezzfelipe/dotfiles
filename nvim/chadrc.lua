---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "catppuccin",
  theme_toggle = { "ayu_light", "catppuccin" },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
