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
        tab.is_current() and "" or "",
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

--[[ This is configuration for Barbar plugin
require("bufferline").setup({
  animation = true,
  closable = false,
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
--]]
