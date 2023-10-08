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

-- [[ Modules -- from Mini.statusline ]]

--- Get filetype icon using devicons
---@return ... __statusline_section
Statusline.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons then return '' end

  local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
  return devicons.get_icon(file_name, file_ext, { default = true })
end

--- Section for Git information
---
--- Normal output contains name of `HEAD` (via |b:gitsigns_head|) and chunk
--- information (via |b:gitsigns_status|). Short output - only name of `HEAD`.
--- Note: requires 'lewis6991/gitsigns' plugin.
---
--- Short output is returned if window width is lower than `args.trunc_width`.
---
---@return __statusline_section
Statusline.section_git = function()
  --if H.isnt_normal_buffer() then return '' end

  local head = vim.b.gitsigns_head or '-'
  --local signs = MiniStatusline.is_truncated(args.trunc_width) and '' or (vim.b.gitsigns_status or '')
  local signs = vim.b.gitsigns_status or ''
  --local icon = args.icon or (H.get_config().use_icons and '' or 'Git')
  local icon = ''

  if signs == '' then
    if head == '-' or head == '' then return '' end
    return string.format('%s %s', icon, head)
  end
  return string.format('%s %s %s', icon, head, signs)
end


--- Section for Neovim's builtin diagnostics
---
--- Shows nothing if there is no attached LSP clients or for short output.
--- Otherwise uses builtin Neovim capabilities to compute and show number of
--- errors ('E'), warnings ('W'), information ('I'), and hints ('H').
---
---@return __statusline_section
Statusline.diagnostics = function()
  if #(vim.lsp.get_active_clients()) == 0 then
    return ""
  end

  local diagnostic_levels = {
    { id = vim.diagnostic.severity.ERROR, sign = "E" },
    { id = vim.diagnostic.severity.WARN,  sign = "W" },
    { id = vim.diagnostic.severity.INFO,  sign = "I" },
    { id = vim.diagnostic.severity.HINT,  sign = "H" },
  }
  local t = {}
  for _, level in ipairs(diagnostic_levels) do
    local n = #vim.diagnostic.get(0, { severity = level.id })
    if n > 0 then table.insert(t, string.format(" %s%s", level.sign, n)) end
  end

  local icon = ""
  if vim.tbl_count(t) == 0 then return ("%s -"):format(icon) end
  return string.format("%s%s", icon, table.concat(t, ""))
end


function test()
  local size = vim.fn.getfsize(vim.fn.getreg('%'))
  if size < 1024 then
    return string.format('%dB', size)
  elseif size < 1048576 then
    return string.format('%.2fKiB', size / 1024)
  else
    return string.format('%.2fMiB', size / 1048576)
  end
end

--[[ build()
-- Build a table with statusline components
-- @return Lua table of Vim statusline components
--]]
Statusline.build = function()
  local mode_info = Statusline.modes[vim.fn.mode()]

  -- Combine Diagnostics and Git info
  local diagnostics_info = Statusline.diagnostics()
  local git_info = Statusline.section_git()
  local diagit = ""
  if diagnostics_info ~= "" and git_info ~= "" then
    diagit = string.format("%s | %s", diagnostics_info, git_info)
  elseif diagnostics_info == "" then
    diagit = git_info
  end

  local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
  if cur_width < 80 then
    -- Short statusline
    -- [Mode] filename_tail[mod][RO] diagit        line : column
    return table.concat({
      -- Mode
      mode_info.hl, " ", mode_info.name, " ",
      -- File info
      "%#MiniStatuslineFilename# ",
      Statusline.get_filetype_icon(), " ",
      "%t%m%r ", --> filename tail
      -- Make above modules the last to be truncated
      "%<",
      -- Extra information
      "%#MiniStatuslineFileinfo# ", diagit,
      -- Spacer
      "%=",
      -- Location
      mode_info.hl, ' %l : %v ',
    })
  else
    -- Long Statusline
    -- [Mode] CWD filepath[mod][RO] diagit        filetype fileformat:enc file_size line/total_line : col/total_col
    return table.concat({
      -- Mode
      mode_info.hl, " ", mode_info.name, " ",
      -- CWD + File info
      "%#MiniStatuslineFilename# ",
      " ", vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      " ", Statusline.get_filetype_icon(), " ",
      "%f%m%r ", --> filepath relative to CWD
      -- Make above modules the last to be truncated
      "%<",
      -- Extra information
      "%#MiniStatuslineFileinfo# ", diagit,
      -- Spacer
      "%=",
      -- Location in the file: line/total_line : column/total_column
      mode_info.hl, ' %l/%L:%2v/%-2{virtcol("$") - 1} ',
    })
  end
end

--[[ setup()
-- Set vim.o.statusline to luaeval of the build function
--]]
Statusline.setup = function()
  vim.opt.statusline = "%{%v:lua.Statusline.build()%}"
end

return Statusline
