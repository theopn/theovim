--[[ init.lua
--
--      \/       \/
--      /\_______/\
--     /   o   o   \
--    (  ==  ^  ==  )
--     )           (
--    (             )
--    ( (  )   (  ) )
--   (__(__)___(__)__)
--  ___
--   | |_  _  _     o __
--   | | |(/_(_)\_/ | |||
--
-- Cat : https://www.asciiart.eu/animals/cats
--      I added a few layers of belly so it looks more like my cat Oliver
-- Logo: $figlet -f mini Theovim
--
-- Initialize all configuration files
--]]

-- Core config modules
require("core")
require("plugins")

-- Theovim built-in UI elements
require("ui.statusline").setup()
require("ui.dashboard").setup()

-- LSP configurations
require("lsp.lsp")
require("lsp.completion")

-- Plugin configurations
require("config.treesitter")
require("config.fuzzy")

-- Other Theovim features
require("misc")

---[[ Safeguards around including user configuration file
local status, _ = pcall(require, "config")
if (not status) then return end
--]]
