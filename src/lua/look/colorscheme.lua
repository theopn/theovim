--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

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
