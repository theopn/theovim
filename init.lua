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
--- Tries calling `require` for the given module.
--- If unsuccessful, prints the error message using `vim.notify()`
---
---@param module string name of the module to `require`
---@return unknown module from `pcall` if the call was successful, otherwise nil
local function safe_require(module)
  local status, loaded_module = pcall(require, module)
  if status then
    return loaded_module
  end
  vim.notify("Error loading the module: " .. module)
  return nil
end

-- Loads core config modules
safe_require("config.opt")
safe_require("config.keymap")
safe_require("config.command")
safe_require("config.autocmd")
safe_require("config.netrw")

-- Loads a built-in diagnostic config
safe_require("config.diagnostic")

-- Loads a config for Lazy.nvim
-- lazy.lua will then
-- 1. Combine Lua modules (returned tables) in `lua/plugins` directory
-- 2. Calls `config` or `setup(opts)` to loads plugins
safe_require("config.lazy")

-- Calls the init.lua of the Theovim built-in UI module package
safe_require("ui")

-- Configures Neovide
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
