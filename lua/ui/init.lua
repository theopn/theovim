--- init.lua for Theovim UI components
--- $ figlet -f hollywood theovim
---          /'  /'
---      --/'--/'
---      /'  /'__     ____     ____   .     ,   O  ,__________
---    /'  /'    )  /'    )  /'    )--|    /  /'  /'    )     )
---  /'  /'    /' /(___,/' /'    /'   |  /' /'  /'    /'    /'
--- (__/'    /(__(________(___,/'    _|/(__(__/'    /'    /(__
---
--- Initialize UI modules

require("ui.statusline").setup()
require("ui.tabline").setup()
require("ui.dashboard").setup()

--- Create a highlight using vim.api.nvim_set_hl
---
---@arg group String for the highlight group, i.e. "name" of the highlight
---@arg properties Lua table containing fg, bg, font information
local create_highlight = function(group, properties)
  vim.api.nvim_set_hl(0, group, properties)
end

--- Wrapper around nvim_get_hl() to extract the value of specified attribute
---
--- If the client is nvim >= 0.9, vim.api.nvim_get_hl is used
--- Else, series of vim.fn is used
---
---@arg name Name of the highlight group
---@arg attribute Attribute user wants to know the value of
local function get_hl_component(name, attribute)
  if vim.api.nvim_get_hl then
    local group = vim.api.nvim_get_hl(0, { name = name })
    return group[attribute]
  else
    local fn = vim.fn
    return fn.synIDattr(fn.synIDtrans(fn.hlID(name)), attribute)
  end
end

--- Create custom highlights
---
local create_custom_hl = function()
  local highlights = {
    -- Invert current tabline color for cleaner look
    TabLineSel = {
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

  for group, properties in pairs(highlights) do
    create_highlight(group, properties)
  end
end

-- Uncomment if you want to invert TabLine highlights
--create_custom_hl()
