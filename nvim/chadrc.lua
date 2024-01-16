---@type ChadrcConfig
local M = {}

M.ui = {
  theme = 'onedark',
  theme_toggle = { "onedark", "one_light" },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
