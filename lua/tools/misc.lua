--[[ misc.lua
-- $ figlet -f doom theovim
--  _   _                     _
-- | | | |                   (_)
-- | |_| |__   ___  _____   ___ _ __ ___
-- | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
-- | |_| | | |  __/ (_) \ V /| | | | | | |
--  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|
--
-- Collection of all miscellaneous Theovim features
--]]

local util = require("tools.util")

local NVIM_CONFIG_PATH = vim.opt.runtimepath:get()[1]

-- Making Theovim update command
do
  local update_cmd = "cd " .. NVIM_CONFIG_PATH .. " && git pull"
  local theovim_git_pull = util.spawn_floating_shell(update_cmd, 0.3, 0.5, "TOP", 24)
  -- nargs ?: 0 or 1, *: > 0, +: > 1 args
  vim.api.nvim_create_user_command("TheovimUpdate",
    function()
      theovim_git_pull()
      --vim.cmd("MasonUpdate")
      --vim.cmd("TSUpdate")
    end, { nargs = 0 })
end

-- {{{ Terminal menu
local terminal_options = {
  -- [[
  -- https://medium.com/@egzvor/vim-splits-cheat-sheet-2bf84fc99962
  --           | :top sp |
  -- |:top vs| |:abo| cu | |:bot vs |
  -- |       | |:bel| rr | |        |
  --           | :bot sp |
  -- botright == bot
  -- ]]
  ["1. Bottom"] = function() vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * 0.3) .. "sp | term") end,
  ["2. Left"] = function() vim.cmd("top " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term") end,
  ["3. Right"] = function() vim.cmd("bot " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term") end,
  ["4. Floating"] = util.spawn_floating_term(),
  ["5. New Tab"] = function() vim.cmd("tabnew | term") end,
}
local term_menu = util.create_select_menu("Where would you like to launch a terminal?", terminal_options)
vim.keymap.set('n', "<leader>z", term_menu,
  { noremap = true, silent = true, desc = "[z]sh: launch terminal" })
-- }}}
