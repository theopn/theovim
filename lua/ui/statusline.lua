--- statusline.lua
--- $ figlet -f stacey theovim
--- ________________________________ _________________
--- 7      77  7  77     77     77  V  77  77        7
--- !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  |
---   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  |
---   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  |
---   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!
---
--- Provide functions to build a Lua table and Luaeval string used for setting up Vim statusline
---
--- Requires MiniStatusline* highlights
---
---@alias __statusline_section string Section string.

local components = require("ui.components")

Statusline = {} --> global so that luaeval can keep calling build() function

-- [[ Mode ]]

-- Metatable containing shorthand notation of the mode and hilight group to be used
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
Statusline.modes = setmetatable({
    ["n"] = { name = "N", hl = "%#MiniStatuslineModeNormal#" },
    ["v"] = { name = "V", hl = "%#MiniStatuslineModeVisual#" },
    ["V"] = { name = "V-LINE", hl = "%#MiniStatuslineModeVisual#" },
    [CTRL_V] = { name = "V-BLOCK", hl = "%#MiniStatuslineModeVisual#" },
    ["s"] = { name = "SEL", hl = "%#MiniStatuslineModeVisual#" },
    ["S"] = { name = "SEL-LINE", hl = "%#MiniStatuslineModeVisual#" },
    [CTRL_S] = { name = "SEL-BLOCK", hl = "%#MiniStatuslineModeVisual#" },
    ["i"] = { name = "I", hl = "%#MiniStatuslineModeInsert#" },
    ["R"] = { name = "R", hl = "%#MiniStatuslineModeReplace#" },
    ["c"] = { name = "CMD", hl = "%#MiniStatuslineModeCommand#" },
    ["r"] = { name = "PROMPT", hl = "%#MiniStatuslineModeOther#" },
    ["!"] = { name = "SH", hl = "%#MiniStatuslineModeOther#" },
    ["t"] = { name = "TERM", hl = "%#MiniStatuslineModeOther#" },
  },
  {
    -- Return unknown by default
    __index = function()
      return { name = "Unknown", hl = "%#MiniStatuslineModeOther#" }
    end,
  })

-- [[ Modules -- left ]]
Statusline.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if not has_devicons then return '' end

  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  return devicons.get_icon(file_name, file_ext, { default = true })
end

-- [[ Modules -- right ]]

--- Present the current location in the buffer in the following format
-- | row/total_row | col/total_col |
---
---@return string
---
local location = function()
  -- Use `virtcol()` to correctly handle multi-byte characters
  return '%l/%L | %2v/%-2{virtcol("$") - 1}'
end



--[[ build()
-- Build a table with statusline components
-- @return Lua table of Vim statusline components
--]]
Statusline.build = function()
  local mode_info = Statusline.modes[vim.fn.mode()]
  return table.concat({
    -- Mode
    mode_info.hl,
    " ",
    mode_info.name,
    " ",

    -- Filename
    "%#MiniStatuslineFilename#",
    " ",
    " ",
    vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), --> current working directory

    " ",
    Statusline.get_filetype_icon(),
    " ",
    "%f",
    "%m", --> Modified flag
    "%r", --> Readonly flag
    " ",

    "%<", --> Truncation starts here (and to the left) if file is too logn

    "%#MiniStatuslineFileinfo#",
    -- LSP info
    " hi hi ",

    -- Git info

    -- Git
    components.git_status(),

    -- Spacer
    --"%#Normal#",
    "%=",

    -- File information
    "   %Y ", --> Same as vim.bo.filetype:upper()

    components.ff_and_enc(), " ",
    -- Location in the file
    --"  󰓾 %l:%c %P ", --> Line, column, and page percentage
    mode_info.hl,
    " ",
    location(),
    " ",
  })
end

--[[ setup()
-- Set vim.o.statusline to luaeval of the build function
--]]
Statusline.setup = function()
  vim.opt.statusline = "%{%v:lua.Statusline.build()%}"
end

return Statusline
