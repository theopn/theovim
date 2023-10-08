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

--- Helper determining whether the buftype is normal
--- For more information see ":h buftype"
---@return boolean is_normal_buf
Statusline.isnt_normal_buffer = function() return vim.bo.buftype ~= "" end

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
  if Statusline.isnt_normal_buffer() then return "" end

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


---
---
---@return __statusline_section
Statusline.filzesize = function()
  local size = vim.fn.getfsize(vim.fn.getreg("%"))
  if size < 1024 then
    return string.format('%dB', size)
  elseif size < 1048576 then
    return string.format('%.2fKiB', size / 1024)
  else
    return string.format('%.2fMiB', size / 1048576)
  end
end


---
---
---@return __statusline_section
Statusline.ff_and_enc = function()
  local ff = vim.bo.fileformat
  if ff == "unix" then
    ff = ""
  elseif ff == "dos" then
    ff = ""
  end
  -- If new file does not have encoding, display global encoding
  local enc = (vim.bo.fileencoding == "") and (vim.o.encoding) or (vim.bo.fileencoding)
  return string.format("%s :%s", ff, enc):upper()
end


--- Build a Statusline for active section.
---
--- If current window is smaller than 100 columns, output the following Statusline:
--- [Mode] filename_tail[mod][RO] diagit        line : column
---
--- Else, output the following Statusline:
--- [Mode] CWD filepath[mod][RO] diagit        file_size filetype file_format:enc line/total_line : col/total_col
---
---@return string Statusline appropriately sized statusline
Statusline.active = function()
  local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
  local is_short = (cur_width < 100)
  local mode_info = Statusline.modes[vim.fn.mode()]

  -- Filepath/filename
  -- If short Statusline: Tail of the filename (filename.ext)
  -- Else: CWD + filepath relative to the CWD
  local path = is_short and string.format(" %s %%t%%m%%r ", Statusline.get_filetype_icon())
      or string.format("  %s %s %%f%%m%%r ", vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), Statusline.get_filetype_icon())

  -- Combine Diagnostics and Git info
  local diagnostics_info = Statusline.diagnostics()
  local git_info = Statusline.section_git()
  local diagit = ""
  if diagnostics_info ~= "" and git_info ~= "" then
    diagit = string.format("%s | %s", diagnostics_info, git_info)
  elseif diagnostics_info == "" then
    diagit = git_info
  end

  -- Location
  -- If short Statusline: line : col
  -- Else: line/total_line : col/total_col
  local location = is_short and string.format("%s %s:%s ", mode_info.hl, "%l", "%2v")
      or string.format("%s %s/%s:%s/%s ", mode_info.hl, "%l", "%L", "%2v", '%-2{virtcol("$") - 1}')

  if cur_width < 100 then
    -- Short statusline
    return table.concat({
      string.format("%s %s ", mode_info.hl, mode_info.name),
      "%#MiniStatuslineFilename#",
      path,
      -- Make above modules the last to be truncated
      "%<",

      -- LSP and Git
      "%#MiniStatuslineFileinfo# ",
      diagit,

      -- Spacer
      "%=",

      location,
    })
  else
    -- Long Statusline
    return table.concat({
      string.format("%s %s ", mode_info.hl, mode_info.name),
      "%#MiniStatuslineFilename#",
      path,
      -- Make above modules the last to be truncated
      "%<",

      -- LSP and Git
      "%#MiniStatuslineDevinfo# ",
      diagit,
      -- Spacer
      "%=",
      -- Extra file information
      "%#MiniStatuslineFilename#",
      string.format(" %s | %s | %s ", Statusline.filzesize(), "%Y", Statusline.ff_and_enc()),
      location,
    })
  end
end

--- Build a simple Statusline for inactive windows
--- Requires no external functions other than built-in Vim Statusline fields
---@return string Statusline
Statusline.inactive = function()
  return "%#MiniStatuslineFilename# %t%m%r %#MiniStatuslineInactive#%=%< %#MiniStatuslineFilename# %l:%v "
end

--- Set the global statusline (safeguard)
--- Make an autocmd to automatically set up active and inactive Statusline
---
Statusline.setup = function()
  -- Safeguard
  vim.opt.statusline = "%{%v:lua.Statusline.active()%}"
  -- Autocmd
  local statusline_augroup = vim.api.nvim_create_augroup("Statusline", {})
  vim.api.nvim_create_autocmd(
    { "WinEnter", "BufEnter", },
    {
      group = statusline_augroup,
      pattern = "*",
      callback = function()
        vim.wo.statusline = "%!v:lua.Statusline.active()"
      end,
      desc = "Set active Statusline"
    })
  vim.api.nvim_create_autocmd(
    { "WinLeave", "BufLeave", },
    {
      group = statusline_augroup,
      pattern = "*",
      callback = function()
        vim.wo.statusline = "%!v:lua.Statusline.inactive()"
      end,
      desc = "Set inactive Statusline"
    })
end

return Statusline
