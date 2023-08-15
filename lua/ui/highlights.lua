--[[ highlights.lu
-- $ figlet -f hollywood theovim
--          /'  /'
--      --/'--/'
--      /'  /'__     ____     ____   .     ,   O  ,__________
--    /'  /'    )  /'    )  /'    )--|    /  /'  /'    )     )
--  /'  /'    /' /(___,/' /'    /'   |  /' /'  /'    /'    /'
-- (__/'    /(__(________(___,/'    _|/(__(__/'    /'    /(__
--
-- Initialize highlights used by Theovim UI modules
--]]
local M = {}

--[[ create_highlights_nvim_api()
-- Create highlights using
--
-- @arg group String for the highlight group, i.e. "name" of the highlight
-- @arg properties Lua table containing fg, bg, font information
--]]
local create_highlight_nvim_api = function(group, properties)
  vim.api.nvim_set_hl(0, group, properties)
end

--[[ create_highlight_vim_cmd()
-- Creates a new highlight group using Vimscript. Suitable for groups with foreground or background only
-- it is slower compared to create_highlights_nvim_api
--   https://www.reddit.com/r/neovim/comments/sihuq7/comment/hvazzwp/?utm_source=share&utm_medium=web2x&context=3
--
-- @arg group: Name of the highlight group to create
-- @arg fg: Foreground hex code. If none is provided, nil is used
-- @arg bg: Background hex code. If none is provided, nil is used
--]]
local create_highlight_vim_cmd = function(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

--[[ get_hl_component()
-- Wrapper around nvim_get_hl() to extract the value of specified attribute
--
-- @arg name Name of the highlight group
-- @arg attribute Attribute user wants to know the value of
--]]
local function get_hl_component(name, attribute)
  local group = vim.api.nvim_get_hl(0, { name = name })
  return group[attribute]
end

--[[
-- Table containing all the highlights to be initialized
--]]
M.highlights = {
  -- Invert current tabline color for cleaner look
  TabLineSel = { fg = get_hl_component("TabLineSel", "bg"), bg = get_hl_component("TabLineSel", "fg"), italic = true, },
  -- Make Winbar same as Statusline with italics
  Winbar = { fg = get_hl_component("StatusLine", "fg"), bg = get_hl_component("StatusLine", "bg"), italic = true },

  -- Custom statusline highlight (from my old colorscheme [Pastelcula](https://github.com/theopn/pastelcula.nvim))
  PastelculaBlueAccent = { fg = "#5AB0F6", },
  PastelculaRedAccent = { fg = "#FAA5A5", },
  PastelculaGreenAccent = { fg = "#BDF7AD", },
  PastelculaYellowAccent = { fg = "#F3FFC2", },
  PastelculaPurpleAccent = { fg = "#D3B3F5", },
  PastelculaOrangeAccent = { fg = "#FFCAA1" },
  PastelculaLightGreyAccent = { fg = "#B7C2C7", italic = true },
  PastelculaGreyAccent = { fg = "#828B8F", },
  -- For the dashboard
  TheovimDraculaOrange = { fg = "#FFB86C" },
  TheovimDraculaCyan = { fg = "#8BE9FD" },
}

--[[ setup()
-- using M.highlights and preferred create_highlight function, create highlights
--]]
M.setup = function()
  for group, properties in pairs(M.highlights) do
    create_highlight_nvim_api(group, properties)
  end
end

return M
