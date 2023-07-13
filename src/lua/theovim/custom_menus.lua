--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

local util = require("theovim_util")

-- {{{ LSP menu
local lsp_options = {
  ["1. Code Action"] = "Lspsaga code_action",
  ["2. References"] = function() vim.lsp.buf.references() end,
  ["3. Current Buffer Diagonostics"] = function() vim.diagnostic.open_float(0, { scope = "buffer", border = "rounded" }) end,
  ["4. Outline"] = "Lspsaga outline",
  ["5. Hover Doc"] = function() vim.lsp.buf.hover() end, -- LSPSaga version requires Markdown treesitter
  ["6. Rename Variable"] = "Lspsaga rename",
  ["7. Linter (Code Auto Format) Toggle"] = "LinterToggle",
}
THEOVIM_LSP_MENU = function()
  if #(vim.lsp.get_active_clients({ bufnr = 0 })) == 0 then
    vim.notify("There is no LSP server attached to the current buffer")
  else
    util.create_select_menu("Code action to perform at the current cursor", lsp_options)() --> Extra paren to execute!
  end
end
-- }}}

-- {{{ Telescope menu
local telescope_options = {
  ["1. Search History"] = "Telescope search_history",
  ["2. Command History"] = "Telescope command_history",
  ["3. Commands"] = "Telescope commands",
  ["4. Help Tags"] = "Telescope help_tags",
  ["5. Colorscheme"] = "Telescope colorscheme"
}
THEOVIM_TELESCOPE_MENU = util.create_select_menu("Telescope option to launch:", telescope_options)
-- }}}

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
