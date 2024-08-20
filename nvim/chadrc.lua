---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "oxocarbon",
  theme_toggle = { "ayu_light", "oxocarbon" },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
