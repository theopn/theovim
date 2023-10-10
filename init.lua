--- init.lua
---
---      \/       \/
---      /\_______/\
---     /   o   o   \
---    (  ==  ^  ==  )
---     )           (
---    (             )
---    ( (  )   (  ) )
---   (__(__)___(__)__)
---  ___
---   | |_  _  _     o __
---   | | |(/_(_)\_/ | |||
---
--- Cat : https://www.asciiart.eu/animals/cats
---      My friend added a few layers of belly so it looks more like chunky my cat Oliver
--- Logo: $ figlet -f mini Theovim
---
--- Initialize all configuration files

--- safe_require()
--- Try calling `require` for the given module.
--- If unsuccessful, print the error message using `vim.notify()`
---
---@param module string a name of the module to `require`
---@return unknown module from `pcall` if the call was successful, otherwise nil
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

-- Telescope and Treesitter
safe_require("tele")
safe_require("ts")

-- LSP
safe_require("lsp")

-- Theovim built-in UI elements
safe_require("ui")

-- Theo's Neovide settings
if vim.g.neovide then
  local padding = 10
  vim.g.neovide_padding_top = padding
  vim.g.neovide_padding_bottom = padding
  vim.g.neovide_padding_right = padding
  vim.g.neovide_padding_left = padding

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.g.neovide_transparency = 0.69
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end
