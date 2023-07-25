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

local util = require("util")

local NVIM_CONFIG_PATH = vim.opt.runtimepath:get()[1]

-- Making Theovim update command
do
  local update_cmd = "cd " .. NVIM_CONFIG_PATH .. " && git pull"
  local theovim_git_pull = util.spawn_floating_shell(update_cmd, 0.3, 0.5, "TOP", 24)
  -- nargs ?: 0 or 1, *: > 0, +: > 1 args
  vim.api.nvim_create_user_command("TheovimUpdate",
    function()
      theovim_git_pull()
      require("lazy").sync()
      --vim.cmd("MasonUpdate")
      --vim.cmd("TSUpdate")
    end, { nargs = 0 })
end

-- Various help document windows
do
  local helpdoc_path = vim.api.nvim_get_runtime_file("docs/theovim-help.md", false)[1]
  local helpdoc_func = util.spawn_floting_doc_win(helpdoc_path)
  vim.api.nvim_create_user_command("TheovimHelp", helpdoc_func, { nargs = 0 })

  local vimhelp_path = vim.api.nvim_get_runtime_file("docs/vim-help.md", false)[1]
  local vimhelp_func = util.spawn_floting_doc_win(vimhelp_path)
  vim.api.nvim_create_user_command("TheovimVanillaVimHelp", vimhelp_func, { nargs = 0 })

  local info_path = vim.api.nvim_get_runtime_file("docs/theovim-info.md", false)[1]
  local info_func = util.spawn_floting_doc_win(info_path)
  vim.api.nvim_create_user_command("TheovimInfo", info_func, { nargs = 0 })
end

do
  vim.api.nvim_create_user_command("Notepad", util.launch_notepad, { nargs = 0 })
end

-- {{{ Git menu
local git_options = {
  ["0. Diff Current Buffer"] = "Git diffthis",
  ["1. Git Commits"] = "Telescope git_commits",
  ["2. Git Status"] = "Telescope git_status"
}
THEOVIM_GIT_MENU = util.create_select_menu("Git functionality to use:", git_options)
-- }}}

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
  ["4. Floating"] = "Lspsaga term_toggle",
  ["5. New Tab"] = function() vim.cmd("tabnew | term") end,
}
THEOVIM_TERMINAL_MENU = util.create_select_menu("Where would you like to launch a terminal?", terminal_options)
-- }}}

-- {{{ Miscellaneous features
local misc_options = {
  ["1. :Notepad"] = "Notepad",
  ["2. :TrimWhitespace"] = "TrimWhitespace",
  ["3. :ShowChanges"] = "ShowChanges",
  ["4. :TheovimUpdate"] = "TheovimUpdate",
  ["5. :TheovimHelp"] = "TheovimHelp",
  ["6. :TheovimVanillaVimHelp"] = "TheovimVanillaVimHelp",
  ["7. :TheovimInfo"] = "TheovimInfo",
}
THEOVIM_MISC_MENU = util.create_select_menu("What fun feature would you like to use?", misc_options)
--}}}