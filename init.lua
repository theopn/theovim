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

-- Core config modules
require("core")
require("plugins")

-- UI
require("ui.statusline").setup()
require("ui.dashboard").setup()

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
local status, _ = pcall(require, "config")
if (not status) then return end
--]]
