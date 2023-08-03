--[[ tabby.lua
--
--]]

local theme = {
  fill = "TabLineFill",
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

require("tabby.tabline").set(function(line)
  return {
    {
      { " Theo  ", hl = theme.fill },
      line.sep(" ", theme.win, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep("", hl, theme.fill),
        tab.is_current() and "" or "󰆣",
        tab.number(),
        tab.name(),
        tab.close_btn(""),
        line.sep("", hl, theme.fill),
        hl = hl,
        margin = " ",
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep(" ", theme.win, theme.fill),
        win.is_current() and "" or "",
        win.buf_name(),
        line.sep(" ", theme.win, theme.fill),
        hl = theme.win,
        margin = " ",
      }
    end),
    {
      line.sep(" ", theme.win, theme.fill),
      { "  ", hl = theme.fill },
    },
    hl = theme.fill,
  }
end)
