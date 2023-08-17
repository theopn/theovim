--[[ config.lua
-- $ figlet -f slant theovim
--    __  __                    _
--   / /_/ /_  ___  ____ _   __(_)___ ___
--  / __/ __ \/ _ \/ __ \ | / / / __ `__ \
-- / /_/ / / /  __/ /_/ / |/ / / / / / / /
-- \__/_/ /_/\___/\____/|___/_/_/ /_/ /_/
--
-- Include your *Lua* personal configuration below
--]]

-- Setting a PDF viewer for a live compilation. Skim for Mac and Zathura for Linux
vim.g.vimtex_view_method = "skim"
--vim.g.vimtex_view_method = "zathura"

-- Theo's Neovide settings
if vim.g.neovide then
  local padding = 10
  vim.g.neovide_padding_top = padding
  vim.g.neovide_padding_bottom = padding
  vim.g.neovide_padding_right = padding
  vim.g.neovide_padding_left = padding

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_vfx_mode = "railgun"
end
