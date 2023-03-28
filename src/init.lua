--[[
Cat: https://www.asciiart.eu/animals/cats
     I added a few layers of belly so it looks more like my cat Oliver
Logo: figlet -f soft Theovim
      soft.flf file can be found in the static folder

"                                                                    "
"                             .---....___                            "
"                    __..--''``          `` _..._    __              "
"          /// //_.-'    .-/';  `         `<._  ``.''_ `. / // /     "
"         ///_.-' _..--.'_    ;                    `( ) ) // //      "
"         / (_..-' // (< _     ;_..__               ; `' / ///       "
"          / // // //  `-._,_)' // / ``--...____..-' /// / //        "
"                                                                    "
" ------------------------- Hi I'm Oliver -------------------------- "
"                                                                    "
"    ,--------.,--.                            ,--.                  "
"    '--.  .--'|  ,---.  ,---.  ,---.,--.  ,--.`--',--,--,--.        "
"       |  |   |  .-.  || .-. :| .-. |\  `'  / ,--.|        |        "
"       |  |   |  | |  |\   --.' '-' ' \    /  |  ||  |  |  |        "
"       `--'   `--' `--' `----' `---'   `--'   `--'`--`--`--'        "
"                                                                    "
--]]
--

-- Lua configs in ~/.config/nvim/lua
-- Remove a hyphen before brackets to disable a module

---[[ Core
require("core.base_config")
require("core.keybindings")
require("core.autocmds")
require("core.plugins")
--]]

---[[ Look
require("look.colorscheme")
require("look.statusline")
require("look.tabline")
--require("look.dashboard")
require("look.dashboard-dev")
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
