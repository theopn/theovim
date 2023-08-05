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

--[[ get_devicon()
-- @arg Name of the buffer
-- @return Icon from the devicons plug-in
--]]
local get_devicon = function(bufname)
  if Winbar.has_devicons then
    local ext = vim.fn.fnamemodify(bufname, ":e")
    local icon = Winbar.devicons.get_icon(bufname, ext, { default = true })
    if icon then return icon end
  end
  return ""
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
    "%#PastelculaLightGreyAccent#",
    " ",
    "%<", --> Truncation starts here so the left separator will be visible at all time

    -- File info
    get_devicon(vim.fn.bufname("%")),
    " %t",
    "%m",
    "%r ",

    -- LSP
    components.lsp_server(),
    components.lsp_status(),

    "%#PastelculaLightGreyAccent#",
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
