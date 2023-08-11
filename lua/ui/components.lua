--[[ components.lua
-- $ figlet -f chunky theovim
--  __   __                       __
-- |  |_|  |--.-----.-----.--.--.|__|.--------.
-- |   _|     |  -__|  _  |  |  ||  ||        |
-- |____|__|__|_____|_____|\___/ |__||__|__|__|
--
-- Provides components for statusline/winbar
--]]
local M = {}

--[[ format_mode()
-- Based on the current Vim mode, format a string to be used for the statusline
-- @return: Formatted string with the current Vim mode information
--]]
M.format_mode = function()
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
M.update_mode_colors = function()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#PastelculaGreyAccent#"
  if current_mode == "n" then
    mode_color = "%#PastelculaBlueAccent#"
  elseif current_mode == "i" then
    mode_color = "%#PastelculaRedAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#PastelculaGreenAccent#"
  elseif current_mode == "c" then
    mode_color = "%#PastelculaPurpleAccent#"
  end
  return mode_color
end

--[[ file_icon()
-- Returns highlighted icon from nvim-web-devicons plug-in
-- usage:
-- M.has_devicons. M.devicons = pcall(require, "nvim-web-devicons")
-- require("ui.components").file_icon(M.has_devicons, M.devicons, vim.fn.bufname("%"))
--
--
-- @arg status First pcall return value
-- @arg module Second pcall return value
-- @arg bufname Name of the buffer
-- @return string in the format :"%#Highlight#<icon>"
--]]
M.file_icon = function(status, module, bufname)
  if status then
    local ext = vim.fn.fnamemodify(bufname, ":e")
    local icon, hl = module.get_icon(bufname, ext, { default = true })
    return string.format("%%#%s#%s", hl, icon)
  end
  return ""
end

--[[ git_status()
-- Using Gitsigns information, create a formatted string for the Git info that the current buffer belongs to
-- Loosely based on: https://github.com/NvChad/ui/blob/main/lua/nvchad_ui/statusline/modules.lua#L65
--
-- @requires Gitsigns plugin
-- @return If Gitsigns info is not available, an empty string. Else, "git-branch-name +line-added ~modified -deleted"
--]]
M.git_status = function()
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

--[[ lsp_server()
-- @return If LSP is not available (outdated Neovim) or client is not found (non-LSP buffer), empty string
--         Else If the current window is too small (vim.o.columns <= 100), a string containing "LSP"
--         Else "LSP: lsp-client-name"
--]]
M.lsp_server = function()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        return "  LSP: " .. client.name
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
M.lsp_status = function()
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

  return string.format("%s%s%s%s ",
    ("%#PastelculaRedAccent#" .. errors), ("%#PastelculaOrangeAccent#" .. warnings),
    ("%#PastelculaYellowAccent#" .. hints), ("%#PastelculaGreenAccent#" .. info))
end

--[[ linter_status()
-- Format a string on whether Linter toggle variable in Theovim is on or off
-- @return a string indicating whether Linter is on or off (if LSP server is not attached, Linter is considered off)
-- @requires vim.g.linter_status variable created in Theovim's LSP settings
--]]
M.linter_status = function()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.server_capabilities.documentFormattingProvider then
        if vim.g.linter_status then
          return " %#PastelculaYellowAccent#󰃢 Linter  "
        end
      end
    end
  end
  return " %#PastelculaRedAccent#󰃢 Linter  "
end

--[[ ff_and_enc()
-- @return a string containing fileformat and encoding information
--]]
M.ff_and_enc = function()
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

return M
