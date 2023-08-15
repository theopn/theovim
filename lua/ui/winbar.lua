--[[ winbar.lua
-- $ figlet -f trek theovim
--  dBBBBBBP dBP dBP dBBBP  dBBBBP dBP dP dBP dBBBBBBb
--                         dBP.BP                  dBP
--   dBP   dBBBBBP dBBP   dBP.BP dB .BP dBP dBPdBPdBP
--  dBP   dBP dBP dBP    dBP.BP  BB.BP dBP dBPdBPdBP
-- dBP   dBP dBP dBBBBP dBBBBP   BBBP dBP dBPdBPdBP
-- Provide tools to build a winbar component with buffer and LSP information
--
-- @requires ui.components for Statusline/Winbar components
--]]
local components = require("ui.components")

Winbar = {}

--[[ excluded_ft
-- List of excluded filetypes
--]]
Winbar.excluded_ft = {
  "help",
  "theovimdashboard",
  "nvimtree",
}

--[[ is_excluded_buf()
-- Check if the given filetype should be excluded from the winbar spawn
-- Lower case version of ft would be considered
-- @return whether
--]]
local is_excluded_buf = function()
  if vim.tbl_contains(Winbar.excluded_ft, string.lower(vim.bo.filetype)) then
    vim.opt_local.winbar = nil --> On a second thought, isn't this useless bc setup() sets it to "" regardless
    return true
  end
  return false
end

--[[ build()
-- Build a winbar with file information and LSP components
--
-- @return string to be used as a Neovim winbar (or Vim statusline)
--]]
function Winbar.build()
  if is_excluded_buf() then
    return ""
  end

  local winbar = table.concat({
    "%#Winbar#",
    " ",

    components.file_icon(Winbar.has_devicons, Winbar.devicons, vim.fn.bufname("%")),
    "%<", --> Truncation starts here so the icon will be visible at all time

    -- File info
    "%#Winbar#",
    " %t",
    "%m",
    "%r ",

    -- LSP
    "%#Winbar#",
    components.lsp_server(),
    components.lsp_status(),

    "%#Winbar#",
    "",

    "%#Normal#"
  })
  return winbar
end

--[[ setup()
-- Set Neovim winbar to be the luaeval of the build() function
--]]
function Winbar.setup()
  Winbar.has_devicons, Winbar.devicons = pcall(require, "nvim-web-devicons")
  vim.opt.winbar = "%{%v:lua.Winbar.build()%}"
end

return Winbar
