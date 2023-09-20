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

--[[ create_highlight()
-- Create a highlight using vim.api.nvim_set_hl
--
-- @arg group String for the highlight group, i.e. "name" of the highlight
-- @arg properties Lua table containing fg, bg, font information
--]]
local create_highlight = function(group, properties)
  vim.api.nvim_set_hl(0, group, properties)
end

--[[ create_highlight_vimscript()
-- Creates a new highlight group using Vimscript. Suitable for groups with foreground or background only
-- it is slower compared to create_highlights_nvim_api
--   https://www.reddit.com/r/neovim/comments/sihuq7/comment/hvazzwp/?utm_source=share&utm_medium=web2x&context=3
--
-- @arg group: Name of the highlight group to create
-- @arg fg: Foreground hex code. If none is provided, nil is used
-- @arg bg: Background hex code. If none is provided, nil is used
--]]
local create_highlight_vimscript = function(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

--[[ get_hl_component()
-- Wrapper around nvim_get_hl() to extract the value of specified attribute
--
-- If the client is nvim >= 0.9, vim.api.nvim_get_hl is used
-- Else, series of vim.fn is used
--
-- @arg name Name of the highlight group
-- @arg attribute Attribute user wants to know the value of
--]]
local function get_hl_component(name, attribute)
  if vim.api.nvim_get_hl then
    local group = vim.api.nvim_get_hl(0, { name = name })
    return group[attribute]
  else
    local fn = vim.fn
    return fn.synIDattr(fn.synIDtrans(fn.hlID(name)), attribute)
  end
end

--[[
-- Table containing all the highlights to be initialized
--]]
M.highlights = {
  -- Invert current tabline color for cleaner look
  TabLineSel = {
    -- For Theovim's Neovim 0.8 compatibility as of V.2023.08.17, we cannot use vim.api.nvim_get_hl()
    fg = get_hl_component("TabLineSel", "bg"),
    bg = get_hl_component("TabLineSel", "fg"),
    italic = true,
  },

  -- Custom Theovim highlights (from my old colorscheme [Pastelcula](https://github.com/theopn/pastelcula.nvim) )
  PastelculaBlueAccent = { fg = "#5AB0F6", },
  PastelculaRedAccent = { fg = "#FAA5A5", },
  PastelculaGreenAccent = { fg = "#BDF7AD", },
  PastelculaYellowAccent = { fg = "#F3FFC2", },
  PastelculaPurpleAccent = { fg = "#D3B3F5", },
  PastelculaOrangeAccent = { fg = "#FFCAA1" },
  PastelculaLightGreyAccent = { fg = "#B7C2C7", italic = true },
  PastelculaGreyAccent = { fg = "#828B8F", },
}

--[[ setup()
-- using M.highlights and preferred create_highlight function, create highlights
--]]
M.setup = function()
  for group, properties in pairs(M.highlights) do
    create_highlight(group, properties)
  end
end

return M
