--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
-- {{{ Theme Settings
require("onedark").setup({
  style = "dark",
  transparent = false,
  toggle_style_key = "<leader>od",
  toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer" },
  code_style = {
    comments = "italic",
    keywords = "bold",
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },
  colors_save = {
    black       = "#151820",
    bg0         = "#282A35",
    bg1         = "#2d3343",
    bg2         = "#343e4f",
    bg3         = "#363c51",
    bg_d        = "#1e242e",
    bg_blue     = "#6db9f7",
    bg_yellow   = "#f0d197",
    fg          = "#dcdede",
    purple      = "#ae79f2",
    green       = "#69c273",
    orange      = "#f29950",
    blue        = "#5ab0f6",
    yellow      = "#faeb89",
    cyan        = "#4dbdcb",
    red         = "#f26161",
    grey        = "#737373",
    light_grey  = "#7d899f",
    dark_cyan   = "#25747d",
    dark_red    = "#a13131",
    dark_yellow = "#9a6b16",
    dark_purple = "#8f36a9",
    diff_add    = "#303d27",
    diff_delete = "#3c2729",
    diff_change = "#18344c",
    diff_text   = "#265478",
  },
})
require("onedark").load()
-- }}}

-- {{{ Bufferline Settings
require("bufferline").setup({
  maximum_padding = 1,
  maximum_length = 30,
  -- New buffer inserted at the end (instead of after curr buffer). Compitability w/ built-in bprev bnext command
  insert_at_end = true, --> Or I can use Barbar's BufferPrevious/BufferNext commands in keybinding...
})
-- Compitability w/ nvim-tree --
local nvim_tree_events = require("nvim-tree.events")
local bufferline_api = require("bufferline.api")
local function get_tree_size() return require("nvim-tree.view").View.width end
nvim_tree_events.subscribe("TreeOpen", function() bufferline_api.set_offset(get_tree_size()) end)
nvim_tree_events.subscribe("Resize", function() bufferline_api.set_offset(get_tree_size()) end)
nvim_tree_events.subscribe("TreeClose", function() bufferline_api.set_offset(0) end)
-- }}}

-- {{{ Dashboard Settings
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
-- }}}
