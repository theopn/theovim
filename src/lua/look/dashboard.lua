--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

require("dashboard").setup({
  theme = 'doom',
  config = {
    header = {
      "", "", "", "", "", "",
      "                                                                    ",
      "                             .---....___                            ",
      "                    __..--''``          `` _..._    __              ",
      "          /// //_.-'    .-/';  `         `<._  ``.''_ `. / // /     ",
      "         ///_.-' _..--.'_    ;                    `( ) ) // //      ",
      "         / (_..-' // (< _     ;_..__               ; `' / ///       ",
      "          / // // //  `-._,_)' // / ``--...____..-' /// / //        ",
      "                                                                    ",
      " ------------------------- Hi I'm Oliver -------------------------- ",
      "                                                                    ",
      "    ,--------.,--.                            ,--.                  ",
      "    '--.  .--'|  ,---.  ,---.  ,---.,--.  ,--.`--',--,--,--.        ",
      "       |  |   |  .-.  || .-. :| .-. |\\  `'  / ,--.|        |        ", --> Quote out of place bc of escape sequence
      "       |  |   |  | |  |\\   --.' '-' ' \\    /  |  ||  |  |  |        ",
      "       `--'   `--' `--' `----' `---'   `--'   `--'`--`--`--'        ",
      "                                                                    ",
      "",
      os.date("                 Today is %A, %d %B %Y                 "),
      "",
    },
    center = {
      {
        icon = "󰥨  ",
        desc = "Find File           ",
        key = "spc ff",
        action = "Telescope find_files",
      },
      {
        icon = "  ",
        desc = "Browse Files        ",
        key = "spc fb",
        action = "Telescope file_browser",
      },
      {
        icon = "  ",
        desc = "New File             ",
        key = "spc n",
        action = "enew",
      },
      {
        icon = "  ",
        desc = "Configure Theovim         ",
        action = "e ~/.config/nvim/lua/user_config.lua",
      },
      {
        icon = "  ",
        desc = "Exit Theovim              ",
        action = "quit",
      },
    },
    footer = { os.date("Theovim %Y") }
  }
})
