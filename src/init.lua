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
require("core/theo_init")
require("core/keybindings")
require("core/plugins")
--]]

---[[ Look
require("look/look")
require("look/statusline")
--]]

---[[ Editor
require("editor/lsp")
require("editor/file_et_search")
--]]

---[[ Theovim
require("theovim/theovim")
require("theovim/custom_menus")
--]]

---[[ Safeguards around including user configuration file
local status, _ = pcall(require, "user_config")
if (not status) then return end
--]]
