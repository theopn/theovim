--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

local tabby_theme = {
  fill = "TabLineFill",
  head = "TabLine",
  current_tab = { fg = "#F8F8F2", bg = "#6272A4", style = "italic" },
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}
require("tabby.tabline").set(function(line)
  return {
    {
      { " Theo  ", hl = tabby_theme.fill },
      line.sep(" ", tabby_theme.win, tabby_theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and tabby_theme.current_tab or tabby_theme.tab
      return {
        line.sep("", hl, tabby_theme.fill),
        tab.is_current() and "" or "󰆣",
        tab.number(),
        tab.name(),
        tab.close_btn(""),
        line.sep("", hl, tabby_theme.fill),
        hl = hl,
        margin = " ",
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep(" ", tabby_theme.win, tabby_theme.fill),
        win.is_current() and "" or "",
        win.buf_name(),
        line.sep(" ", tabby_theme.win, tabby_theme.fill),
        hl = tabby_theme.win,
        margin = " ",
      }
    end),
    {
      line.sep(" ", tabby_theme.win, tabby_theme.fill),
      { "  ", hl = tabby_theme.fill },
    },
    hl = tabby_theme.fill,
  }
end)
