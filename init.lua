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

-- Try catch for modules
local function safe_require(module)
  local status, loaded_module = pcall(require, module)
  if status then
    return loaded_module
  end
  vim.notify("Error loading the module: " .. module)
  return nil
end

-- Core config modules
safe_require("core")
safe_require("plugins")

-- Theovim built-in UI elements
local statusline = safe_require("ui.statusline")
if statusline then statusline.setup() end
local winbar = safe_require("ui.winbar")
if winbar then winbar.setup() end
local dashboard = safe_require("ui.dashboard")
if dashboard then dashboard.setup() end
require("ui.tabline").setup()
--require("ui.buf").setup()

-- LSP configurations
safe_require("lsp.lsp")
safe_require("lsp.completion")

-- Plugin configurations
safe_require("config.fuzzy")
safe_require("config.treesitter")

-- Other Theovim features
safe_require("misc")

-- User configuration
safe_require("config")
