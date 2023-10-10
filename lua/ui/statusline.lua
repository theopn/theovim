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

Statusline = {} --> global so that luaeval can keep calling build() function

--- [Credit] Direct port of Mini.Statusline module
--- Helper determining whether the buftype is normal
---@return boolean is_normal_buf
Statusline.isnt_normal_buffer = function()
  -- For more information see ":h buftype"
  return vim.bo.buftype ~= ""
end

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


--- [Credit] Direct port of Mini.Statusline module
Statusline.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  --local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  --if not has_devicons then return '' end
  if not Statusline.has_devicons then return '' end

  local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
  --return devicons.get_icon(file_name, file_ext, { default = true })
  return Statusline.devicons.get_icon(file_name, file_ext, { default = true })
end


--- [Credit] Direct port of Mini.Statusline module
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


--- [Credit] Direct port of Mini.Statusline module
--- Section for Neovim's builtin diagnostics
---
--- Shows nothing if there is no attached LSP clients or for short output.
--- Otherwise uses builtin Neovim capabilities to compute and show number of
--- errors ('E'), warnings ('W'), information ('I'), and hints ('H').
---
---@return __statusline_section
Statusline.diagnostics = function()
  -- Added by me
  local diagnostic_levels = {
    { id = vim.diagnostic.severity.ERROR, sign = 'E' },
    { id = vim.diagnostic.severity.WARN,  sign = 'W' },
    { id = vim.diagnostic.severity.INFO,  sign = 'I' },
    { id = vim.diagnostic.severity.HINT,  sign = 'H' },
  }
  local get_diagnostic_count = function(id) return #vim.diagnostic.get(0, { severity = id }) end
  -- Added by me

  -- Assumption: there are no attached clients if table
  -- `vim.lsp.buf_get_clients()` is empty
  local hasnt_attached_client = next(vim.lsp.buf_get_clients()) == nil
  --local dont_show_lsp = MiniStatusline.is_truncated(args.trunc_width) or H.isnt_normal_buffer() or hasnt_attached_client
  local dont_show_lsp = Statusline.isnt_normal_buffer() or hasnt_attached_client
  if dont_show_lsp then return '' end

  -- Construct diagnostic info using predefined order
  local t = {}
  --for _, level in ipairs(H.diagnostic_levels) do
  for _, level in ipairs(diagnostic_levels) do
    --local n = H.get_diagnostic_count(level.id)
    local n = get_diagnostic_count(level.id)
    -- Add level info only if diagnostic is present
    if n > 0 then table.insert(t, string.format(' %s%s', level.sign, n)) end
  end

  --local icon = args.icon or (H.get_config().use_icons and '' or 'LSP')
  local icon = ' '
  if vim.tbl_count(t) == 0 then return ('%s -'):format(icon) end
  return string.format('%s%s', icon, table.concat(t, ''))
end


--- Format Filetype (%Y through Statusline field), file size, fileformat, and encoding
---
---@return __statusline_section
Statusline.file_info = function()
  if Statusline.isnt_normal_buffer() then return "" end

  local ff = vim.bo.fileformat
  if ff == "unix" then
    ff = ""
  elseif ff == "dos" then
    ff = ""
  end

  -- If new file does not have encoding, display global encoding
  local enc = (vim.bo.fileencoding == "") and (vim.o.encoding) or (vim.bo.fileencoding)

  -- Calculate size
  local size = vim.fn.getfsize(vim.fn.getreg("%"))
  if size < 1024 then
    size = string.format("%dB", size)
  elseif size < 1048576 then
    size = string.format("%.2fKiB", size / 1024)
  else
    size = string.format("%.2fMiB", size / 1048576)
  end

  return string.format(" %%Y | %s | %s | %s ", size, ff, enc:upper())
end


--- Build a Statusline for active section.
---
--- If current window is smaller than 100 columns, output the following Statusline:
--- [Mode] filename_tail[mod][RO] diagit        line : column
---
--- Else, output the following Statusline:
--- [Mode] CWD filepath[mod][RO] diagit        filetype file_size file_format:enc line/total_line : col/total_col
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
  local diagit = Statusline.diagnostics()
  local git_info = Statusline.section_git()
  if diagit ~= "" and git_info ~= "" then
    diagit = string.format(" %s | %s ", diagit, git_info)
  elseif diagit == "" and git_info ~= "" then
    diagit = string.format(" %s ", git_info)
  elseif diagit ~= "" and git_info == "" then
    diagit = string.format(" %s ", diagit)
  end

  -- Fileinfo
  -- If short Statusline: ""
  -- Else: Filetype | Filesize | File format (Unix or Dos) | Encoding
  local file_info = is_short and "" or Statusline.file_info()

  -- Location
  -- If short Statusline: line : col
  -- Else: line/total_line : col/total_col
  local location = is_short and string.format("%s %s:%s ", mode_info.hl, "%l", "%2v")
      or string.format("%s %s/%s:%s/%s ", mode_info.hl, "%l", "%L", "%2v", '%-2{virtcol("$") - 1}')

  return table.concat({
    string.format("%s %s ", mode_info.hl, mode_info.name),
    "%#MiniStatuslineFilename#",
    path,
    "%<", --> Make above modules the last to be truncated
    "%#MiniStatuslineDevinfo#",
    diagit,
    "%#MiniStatuslineInactive#",
    "%=", --> Spacer
    "%#MiniStatuslineFilename#",
    file_info,
    location,
  })
end

--- Build a simple Statusline for inactive windows
--- Requires no external functions other than built-in Vim Statusline fields
---@return string Statusline
Statusline.inactive = function()
  return "%#MiniStatuslineFilename# %t%m%r %#MiniStatuslineInactive#%=%< %#MiniStatuslineFileinfo# %l:%v "
end

--- Set the global statusline (safeguard)
--- Make an autocmd to automatically set up active and inactive Statusline
---
Statusline.setup = function()
  Statusline.has_devicons, Statusline.devicons = pcall(require, "nvim-web-devicons")

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
        -- No need for eval since inactive Statusline is a simple string
        vim.wo.statusline = Statusline.inactive()
      end,
      desc = "Set inactive Statusline"
    })
end

return Statusline
