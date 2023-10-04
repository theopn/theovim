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
--      My friend added a few layers of belly so it looks more like chunky my cat Oliver
-- Logo: $ figlet -f mini Theovim
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

-- User configuration
safe_require("config")

-- Core config modules
safe_require("core")
safe_require("plugins")

-- Telescope and Treesitter
safe_require("tele")
safe_require("ts")

-- LSP
safe_require("lsp")

-- Theovim built-in UI elements
safe_require("ui")
