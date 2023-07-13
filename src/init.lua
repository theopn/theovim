--[[
Cat: https://www.asciiart.eu/animals/cats
     I added a few layers of belly so it looks more like my cat Oliver

     \/       \/
     /\_______/\
    /   o   o   \
   (  ==  ^  ==  )
    )           (
   (             )
   ( (  )   (  ) )
  (__(__)___(__)__)
 ___
  | |_  _  _     o __
  | | |(/_(_)\_/ | |||

--]]
--

-- Lua configs in ~/.config/nvim/lua
-- Remove a hyphen before brackets to disable a module

---[[ Core
require("core")
require("plugins")
--]]

---[[ Look
require("look.colorscheme")
require("look.statusline")
require("look.tabline")
require("look.dashboard")
--]]

---[[ Editor
require("editor.tree_sitter")
require("editor.fuzzy_finder")
require("editor.lsp")
require("editor.completion")
--]]

---[[ Theovim
require("theovim.theovim_cmd")
require("theovim.custom_menus")
--]]

---[[ Safeguards around including user configuration file
local status, _ = pcall(require, "user_config")
if (not status) then return end
--]]
