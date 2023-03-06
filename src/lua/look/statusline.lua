--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

--[[
Inspired by examples/evil_lualine.lua in the plug-in repository, but utilizing position B and Y
+-------------------------------------------------+
| A | B | C                             X | Y | Z |
+-------------------------------------------------+
--]]
local lualine = require("lualine")

local colors = {
  bg           = "#282a36",
  current_line = "#6272a4",
  fg           = "#f8f8f2",
  comment      = "#6272a4",
  cyan         = "#8be9fd",
  green        = "#50fa7b",
  orange       = "#ffb86c",
  pink         = "#ff79c6",
  purple       = "#bd93f9",
  red          = "#ff5555",
  yellow       = "#f1fa8c",
  darkblue     = '#081633',
  violet       = '#a9a1e1',
  magenta      = '#c678dd',
  blue         = '#51afef',
}

-- Remove defaults
local config = {
  options = {
    globalstatus = true, --> One statusline for all
    disabled_filetypes = { statusline = { "TheovimDashboard" } },
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    -- Default is lualine_c = { { "filename", filestatus = true, path 0 } } (0 for name, 1 for rel path, 2 abs path)
    lualine_x = { "diagnostics" }, --> Add on diagnostics
  },
}

local function ins_far_left(component)
  table.insert(config.sections.lualine_b, component) -- Region A should not be used for custom Lualine (highlighting issue)
end

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local function ins_far_right(component)
  table.insert(config.sections.lualine_y, component) -- Region Z should not be used for custom Lualine, see above
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end
}

-- Reminder that you can invoke Lua function without parentheses, but moving forward I prefer having them
ins_far_left {
  function() return '' end,
  color = { fg = colors.blue },
  padding = { left = 0, right = 1 },
}

ins_far_left({
  function() return ' ' .. vim.fn.mode() end,
  color = function()
    local mode_color = {
      n = colors.current_line,
      no = colors.current_line,
      i = colors.cyan,
      v = colors.yellow,
      [''] = colors.yellow,
      V = colors.yellow,
      R = colors.orange,
      rm = colors.orange,
      ['r?'] = colors.orange,
      t = colors.purple,
      ['!'] = colors.purple,
      c = colors.bg,
      ic = colors.bg,
      cv = colors.bg,
      ce = colors.bg,
      -- Modes that I'm not interested in are all rendered in comment color
      s = colors.comment,
      S = colors.comment,
      [''] = colors.comment,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
})

ins_left({
  "filename",
  icon = '',
  color = { fg = colors.magenta, gui = "bold" },
  cond = conditions.buffer_not_empty,
})

ins_left({
  "branch",
  color = { fg = colors.pink, gui = "bold" },
})

ins_left({
  "diff",
  cond = conditions.hide_in_width,
})

ins_left({
  function() return "▊" end,
  color = { fg = colors.comment },
})

-- Making the middle section
ins_left({
  function()
    return "%=" -- Big empty room so that ins_left inserts to the middle
  end,
})

ins_left({
  function()
    local no_msg = "No LSP"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return no_msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return no_msg
  end,
  icon = " ",
  color = { fg = colors.cyan, gui = "bold" },
  cond = conditions.hide_in_width,
})

ins_left {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  cond = conditions.hide_in_width,
}

ins_right({
  function() return "▊" end,
  color = { fg = colors.comment },
})

ins_right({ "filetype", color = { fg = colors.orange, gui = "bold" } })

ins_right({
  "o:encoding",
  fmt = string.upper,
  color = { fg = colors.green, gui = "bold" },
  cond = conditions.hide_in_width,
})

ins_right({
  "fileformat",
  fmt = string.upper,
  icons_enabled = true, -- Prints out UNIX or penguin icon
  color = { fg = colors.green, gui = "bold" },
  cond = conditions.hide_in_width,
})

ins_far_right({ "location" })

ins_far_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_far_right({
  function() return '' end,
  color = { fg = colors.blue },
  padding = { left = 1 },
})

lualine.setup(config)
