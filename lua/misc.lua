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
      --vim.cmd("MasonUpdate")
      --vim.cmd("TSUpdate")
    end, { nargs = 0 })
end

-- Help document windows
do
  local readme_path = vim.api.nvim_get_runtime_file("README.md", false)[1]
  local helpdoc_func = util.spawn_floting_doc_win(readme_path)
  vim.api.nvim_create_user_command("TheovimReadme", helpdoc_func, { nargs = 0 })

  local changelog_path = vim.api.nvim_get_runtime_file("CHANGELOG.md", false)[1]
  local changelog_func = util.spawn_floting_doc_win(changelog_path)
  vim.api.nvim_create_user_command("TheovimChangelog", changelog_func, { nargs = 0 })

  local changlog_hist_path = vim.api.nvim_get_runtime_file("doc/changelog-history.md", false)[1]
  local changelog_hist_func = util.spawn_floting_doc_win(changlog_hist_path)
  vim.api.nvim_create_user_command("TheovimChangelogHistory", changelog_hist_func, { nargs = 0 })
end

-- {{{ Git menu
local git_options = {
  ["0. Diff Current Buffer"] = "Git diffthis",
  ["1. Git Commits"] = "Telescope git_commits",
  ["2. Git Status"] = "Telescope git_status"
}
local git_menu = util.create_select_menu("Git functionality to use:", git_options)
vim.keymap.set('n', "<leader>g", git_menu,
  { noremap = true, silent = true, desc = "[g]it: open the menu to perform Git features" })
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
  ["4. Floating"] = util.spawn_floating_term(),
  ["5. New Tab"] = function() vim.cmd("tabnew | term") end,
}
local term_menu = util.create_select_menu("Where would you like to launch a terminal?", terminal_options)
vim.keymap.set('n', "<leader>z", term_menu,
  { noremap = true, silent = true, desc = "[z]sh: launch terminal" })
-- }}}

-- {{{ Miscellaneous features
local misc_options = {
  ["1. :Notepad"] = "Notepad",
  ["2. :TrimWhitespace"] = "TrimWhitespace",
  ["3. :ShowChanges"] = "ShowChanges",
  ["4. :TheovimUpdate"] = "TheovimUpdate",
  ["5. :TheovimReadme"] = "TheovimReadme",
  ["6. :TheovimChangelog"] = "TheovimChangelog",
}
local misc_menu = util.create_select_menu("What fun feature would you like to use?", misc_options)
vim.keymap.set('n', "<leader>m", misc_menu,
  { noremap = true, silent = true, desc = "[m]isc: open menu to use other miscellaneous Theovim features" })
--}}}
