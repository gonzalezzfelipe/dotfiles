---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "kanagawa",
  theme_toggle = { "ayu_light", "kanagawa" },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
