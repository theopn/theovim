--[[ statusline.lua
-- $ figlet -f stacey theovim
-- ________________________________ _________________
-- 7      77  7  77     77     77  V  77  77        7
-- !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  |
--   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  |
--   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  |
--   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!
--
-- Provide functions to build a Lua table and Luaeval string used for setting up Vim statusline
--]]
Statusline = {} --> This is global so that luaeval can keep calling build() function

--[[ create_highlight()
-- Creates a new highlight group. Suitable for groups with foreground or background only
-- @arg group: Name of the highlight group to create
-- @arg fg: Foreground hex code. If none is provided, nil is used
-- @arg bg: Background hex code. If none is provided, nil is used
--]]
local function create_highlight(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

-- Create highlight groups
create_highlight("StatusLineBlueAccent", "#5AB0F6", nil)
create_highlight("StatusLineRedAccent", "#FAA5A5", nil)
create_highlight("StatusLineGreenAccent", "#BDF7AD", nil)
create_highlight("StatusLineYellowAccent", "#F3FFC2", nil)
create_highlight("StatusLinePurpleAccent", "#D3B3F5", nil)
create_highlight("StatusLineOrangeAccent", "#FFCAA1")
create_highlight("StatusLineLightGreyAccent", "#B7C2C7")
create_highlight("StatusLineGreyAccent", "#828B8F", nil)

--[[ format_mode()
-- Based on the current Vim mode, format a string to be used for the statusline
-- @return: Formatted string with the current Vim mode information
--]]
local function format_mode()
  -- Table for mode names
  local modes = {
    ["n"] = "N",
    ["no"] = "N Operator Pending",
    ["niI"] = "Insert-N",
    ["v"] = "V",
    ["V"] = "V LINE",
    [""] = "V BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "I",
    ["ic"] = "I COMPLETION",
    ["R"] = "R",
    ["Rv"] = "V REPLACE",
    ["c"] = "CMD",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SH",
    ["t"] = "TERM",
    ["nt"] = "N TERM",
  }
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" 󰄛 %s ",
    (modes[current_mode] ~= nil) and (modes[current_mode]) or (current_mode), ""):upper()
end

--[[ update_mode_colors()
-- @return String containing highlight group for the current mode
--]]
local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineGreyAccent#"
  if current_mode == "n" then
    mode_color = "%#StatusLineBlueAccent#"
  elseif current_mode == "i" then
    mode_color = "%#StatusLineRedAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#StatusLineGreenAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatusLinePurpleAccent#"
  end
  return mode_color
end

--[[ git()
-- Using Gitsigns information, create a formatted string for the Git info that the current buffer belongs to
-- Loosely based on: https://github.com/NvChad/ui/blob/main/lua/nvchad_ui/statusline/modules.lua#L65
--
-- @requires Gitsigns plugin
-- @return If Gitsigns info is not available, an empty string. Else, "git-branch-name +line-added ~modified -deleted"
--]]
local function git()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("+" .. git_status.added) or ("")
  local changed = (git_status.changed and git_status.changed ~= 0) and ("~" .. git_status.changed) or ("")
  local removed = (git_status.removed and git_status.removed ~= 0) and ("-" .. git_status.removed) or ("")
  local branch_name = " " .. git_status.head

  return string.format("%s %s %s %s", branch_name, added, changed, removed)
end

-- Current LSP server
--[[ lsp_server()
-- @return If LSP is not available (outdated Neovim) or client is not found (non-LSP buffer), empty string
--         Else If the current window is too small (vim.o.columns <= 100), a string containing "LSP"
--         Else "LSP: lsp-client-name"
--]]
local function lsp_server()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        return (vim.o.columns <= 100) and ("  LSP ") or ("  LSP: " .. client.name)
      end
    end
  end
  return ""
end

--[[ lsp_status()
-- Format a string for LSP diagnostic info
-- Inspriation: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
-- @return If LSP is not available (outdated Neovim) or client is not found (non-LSP buffer), empty string
--         Else Formatted string of number of errors, warnings, hints, and info (not included if 0)
--]]
local function lsp_status()
  if not rawget(vim, "lsp") or #(vim.lsp.get_active_clients()) == 0 then
    return ""
  end

  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }
  for k, level in pairs(levels) do
    -- OP used vim.tbl_count, but I think Lua built=in # is better
    count[k] = #(vim.diagnostic.get(0, { severity = level })) --> 0 for current buf
  end

  local errors = (count["errors"] > 0) and (" 󰅙 " .. count["errors"]) or ("")
  local warnings = (count["warnings"] > 0) and ("  " .. count["warnings"]) or ("")
  local hints = (count["hints"] > 0) and (" 󰌵 " .. count["hints"]) or ("")
  local info = (count["info"] > 0) and (" 󰋼 " .. count["info"]) or ("")

  return string.format("%s%s%s%s",
    ("%#StatusLineRedAccent#" .. errors), ("%#StatusLineOrangeAccent#" .. warnings),
    ("%#StatusLineYellowAccent#" .. hints), ("%#StatusLineGreenAccent#" .. info))
end

--[[ linter_status()
-- Format a string on whether Linter toggle variable in Theovim is on or off
-- @return a string indicating whether Linter is on or off (if LSP server is not attached, Linter is considered off)
-- @requires vim.g.linter_status variable created in Theovim's LSP settings
--]]
local function linter_status()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.server_capabilities.documentFormattingProvider then
        if vim.g.linter_status then
          --return " %#StatusLineYellowAccent#󰃢 Linter:  "
          return " %#StatusLineYellowAccent#󰃢 Linter: on"
        end
      end
    end
  end
  return " %#StatusLineRedAccent#󰃢 Linter: off"
end

--[[ ff_and_enc()
-- @return a string containing fileformat and encoding information
--]]
local function ff_and_enc()
  local ff = vim.bo.fileformat
  if ff == "unix" then
    ff = "  "
  elseif ff == "dos" then
    ff = "  "
  end
  -- If new file does not have encoding, display global encoding
  local enc = (vim.bo.fileencoding == "") and (vim.o.encoding) or (vim.bo.fileencoding)
  return string.format("%s:%s", ff, enc):upper()
end

--[[ build()
-- Build a table with statusline components
-- @return Lua table of Vim statusline components
--]]
Statusline.build = function()
  return table.concat({
    -- Mode
    update_mode_colors(), --> Dynamically set the highlight depending on the current mode
    format_mode(),

    -- folder, file name, and status
    "%#StatusLineOrangeAccent# ",
    " ",
    vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), --> current working directory
    "  ",
    "%f",                                      --> Current file/path relative to the current folder
    "%m",                                      --> [-] for read only, [+] for modified buffer
    "%r",                                      --> [RO] for read only, I know it's redundant

    -- Git
    " %#StatusLineRedAccent#",
    "%<", --> Truncation starts here if file is too logn
    git(),

    -- Spacer
    "%#Normal#",
    "%=",

    -- LSP
    "%#StatusLineBlueAccent#",
    lsp_server(),
    lsp_status(),
    linter_status(),

    -- File information
    "%#StatusLinePurpleAccent#",
    "   %Y", --> Same as vim.bo.filetype:upper()

    ff_and_enc(),
    -- Location in the file
    "  󰓾 %l:%c %P " --> Line, column, and page percentage
  })
end

--[[ setup()
-- Set vim.o.statusline to luaeval of the build function
--]]
Statusline.setup = function()
  vim.o.statusline = "%!luaeval('Statusline.build()')" --> vim.wo won't work with term window or floating
end

return Statusline
