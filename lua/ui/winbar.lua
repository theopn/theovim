--[[ winbar.lua
-- $ figlet -f trek theovim
--  dBBBBBBP dBP dBP dBBBP  dBBBBP dBP dP dBP dBBBBBBb
--                         dBP.BP                  dBP
--   dBP   dBBBBBP dBBP   dBP.BP dB .BP dBP dBPdBPdBP
--  dBP   dBP dBP dBP    dBP.BP  BB.BP dBP dBPdBPdBP
-- dBP   dBP dBP dBBBBP dBBBBP   BBBP dBP dBPdBPdBP
-- Provide tools to build a winbar component with buffer and LSP information
--]]
Winbar = {}

-- Check if devicon is available
local status, devicons = pcall(require, "nvim-web-devicons")
if status then devicons.setup() end

--[[ is_excluded_buf()
-- Check if the given filetype should be excluded from the winbar spawn
-- Lower case version of ft would be considered
-- e.g.: if not is_excluded_buf(vim.bo.filetype) then ... end
--
-- @arg ft Filetype to be evaluated
--]]
local is_excluded_buf = function(ft)
  local excluded_ft = {
    "help",
    "theovimdashboard",
    "dashboard",
    "lazy",
    "nvimtree",
    "", --> for things like terminal
  }
  if vim.tbl_contains(excluded_ft, string.lower(ft)) then
    return true
  end
  return false
end

--[[ build()
-- Build a winbar with file information and LSP components
--
-- @return string to be used as a Neovim winbar (or Vim statusline)
--]]
Winbar.build = function()
  --[[
  if is_excluded_buf(vim.bo.filetype) then
    vim.wo[vim.api.nvim_get_current_win()].winbar = nil
    return nil
  end
  --]]
  local winbar = table.concat({
    "%#Statusline#",
    " ",
    status and devicons.get_icon_color_by_filetype(vim.bo.filetype) or "󰄛",
    " %t",
    "%#StatuslineNC#",
    " ",
  })
  return winbar
end


--[[ setup()
-- Set Neovim winbar to be the luaeval of the build() function
--]]
Winbar.setup = function()
  vim.opt.winbar = "%!v:lua.Winbar.build()"
end

return Winbar
