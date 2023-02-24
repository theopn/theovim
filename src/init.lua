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
require("theo_init")
require("plugins")
require("look")

require("file_et_search")
require("lsp")

require("theovim")
require("custom_menus")

local status, user_config_call = pcall(require, "user_config")
if (not status) then return end
