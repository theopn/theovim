--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

-- Creating highlight groups
local function create_highlight(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

-- For modes
create_highlight("StatusLineFGAccent", "#93F5F5", nil)
create_highlight("StatusLineBlueAccent", "#5AB0F6", nil)
create_highlight("StatusLineRedAccent", "#FAA5A5", nil)
create_highlight("StatusLineGreenAccent", "#BDF7AD", nil)
create_highlight("StatusLineYellowAccent", "#F3FFC2", nil)
create_highlight("StatusLinePurpleAccent", "#D3B3F5", nil)
create_highlight("StatusLineGreyAccent", "#828B8F", nil)

-- For other components
create_highlight("StatusLineOrangeAccent", "#FFCAA1")
create_highlight("StatusLineLightGreyAccent", "#B7C2C7")

-- Table for mode names
local modes = {
  ["n"] = "N",
  ["no"] = "N Operator Pending",
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

-- Format the mode
local function format_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format("%s %s %s %s",
    "", "󰄛", (modes[current_mode] ~= nil) and (modes[current_mode]) or (current_mode), ""):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineFGAccent#"
  if current_mode == "n" or current_mode == "nt" then
    mode_color = "%#StatuslineBlueAccent#"
  elseif current_mode == "i" or current_mode == "ic" then
    mode_color = "%#StatuslineRedAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#StatuslineGreenAccent#"
  elseif current_mode == "R" then
    mode_color = "%#StatuslineYellowAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatuslinePurpleAccent#"
  elseif current_mode == "t" then
    mode_color = "%#StatuslineGreyAccent#"
  end
  return mode_color
end

-- This appends to get_filename() if file is in a different directory
local function get_filepath()
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if filepath == "" or filepath == "." then
    return " "
  end
  return string.format(" %%<%s/", filepath)
end

local function get_filename()
  local filename = vim.fn.expand "%:t"
  return filename .. "%m" --> %m for modified flag
end


-- Git info using Gitsigns
-- Loosely based on: https://github.com/NvChad/ui/blob/main/lua/nvchad_ui/statusline/modules.lua#L65
local function git()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and (" " .. git_status.added) or ("")
  local changed = (git_status.changed and git_status.changed ~= 0) and (" " .. git_status.changed) or ("")
  local removed = (git_status.removed and git_status.removed ~= 0) and (" " .. git_status.removed) or ("")
  local branch_name = " " .. git_status.head

  return string.format(" %s %s %s %s", branch_name, added, changed, removed)
end

-- Current LSP server
local function lsp_server()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        return (vim.o.columns > 100) and ("  LSP: " .. client.name) or ("  LSP ")
      end
    end
  end
  return ""
end

-- Inspriation: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
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

  local errors = (count["errors"] > 0) and ("  " .. count["errors"]) or ("")
  local warnings = (count["warnings"] > 0) and ("  " .. count["warnings"]) or ("")
  local hints = (count["hints"] > 0) and ("  " .. count["hints"]) or ("")
  local info = (count["info"] > 0) and ("  " .. count["info"]) or ("")

  return string.format("%s%s%s%s",
    ("%#StatusLineRedAccent#" .. errors), ("%#StatusLineOrangeAccent#" .. warnings),
    ("%#StatusLineYellowAccent#" .. hints), ("%#StatusLineGreenAccent#" .. info))
end

-- For Theovim's code auto format toggle functionalities
local function auto_format_status()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.server_capabilities.documentFormattingProvider then
        return (CODE_FORMAT_STATUS) and (" %#StatusLineYellowAccent#󰃢 Linter:  ") or
            (" %#StatusLineRedAccent#󰃢 Linter:  ")
      end
    end
  end
  return " %#StatusLineRedAccent#󰃢 Linter:  " --> Should I make it an empty string?
end

local function enc_and_ff()
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

Statusline = {} --> Must be global
Statusline.build = function()
  return table.concat({
    update_mode_colors(), --> Dynamically set the highlight depending on the current mode
    format_mode(),
    "%#StatusLineOrangeAccent# ",
    "",
    get_filepath(),
    get_filename(),
    "%#StatusLineRedAccent# ",
    git(),

    --"%#Normal#",
    "%=", --> vim statusline separator; inserts equal amount of space per separator
    (vim.bo.readonly) and ("Warning: Read Only") or (""),
    "%=",

    "%#StatusLineBlueAccent# ",
    lsp_server(),
    lsp_status(),
    auto_format_status(),
    "%#StatusLinePurpleAccent# ",
    "  %Y", --> Same as vim.bo.filetype:upper()
    enc_and_ff(),
    "%#StatusLineLightGreyAccent# ",
    " 󰓾 %l:%c %P "
  })
end

vim.o.statusline = "%!luaeval('Statusline.build()')" --> vim.wo won't work with term window or floating
