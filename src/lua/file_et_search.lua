--[[
" figlet -f small theovim-file,search
"  _   _                _           __ _ _                           _
" | |_| |_  ___ _____ _(_)_ __ ___ / _(_) |___   ___ ___ __ _ _ _ __| |_
" |  _| ' \/ -_) _ \ V / | '  \___|  _| | / -_)_(_-</ -_) _` | '_/ _| ' \
"  \__|_||_\___\___/\_/|_|_|_|_|  |_| |_|_\___( )__/\___\__,_|_| \__|_||_|
"                                             |/
--]]
--
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
  ["1. Bottom"] = function()
    vim.api.nvim_command("botright " .. math.ceil(vim.fn.winheight(0) * 0.3) .. "sp | term")
  end,
  ["2. Right"] = function() vim.api.nvim_command("bot " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term") end,
  ["3. Floating"] = function() require("lspsaga.floaterm"):open_float_terminal() end,
  ["4. New Tab"] = function() vim.cmd("term") end,
}
local terminal_option_names = {}
local n = 0
for i, _ in pairs(terminal_options) do
  n = n + 1
  terminal_option_names[n] = i
end
table.sort(terminal_option_names)
function THEOVIM_TERMINAL_MENU()
  vim.ui.select(terminal_option_names, {
    prompt = "Where would you like to launch a terminal?",
  },
    function(choice)
      local action_func = terminal_options[choice]
      if action_func ~= nil then
        action_func()
      end
    end)
end

-- Automatically close the terminal when exit
-- TODO: Translate the following to Lua
-- autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
local terminal_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  group = terminal_augroup,
  callback = function()
    vim.api.nvim_input("<CR>")
  end
})
-- }}}

-- {{{ Templates
local template_augroup = vim.api.nvim_create_augroup("Template", { clear = true })
local function add_template(pattern, file_path)
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = template_augroup,
    pattern = pattern,
    callback = function()
      vim.cmd("0r " .. file_path)
    end
  })
end

add_template("*.tex", "~/.theovim/templates/latex-hw-template.tex")
add_template("*.h", "~/.theovim/templates/c-header-template.h")
--}}}

-- {{{ Tree Sitter Settings
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "latex", "lua", "markdown", "python", "vim", },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  }
})
-- }}}

-- {{{ Telescope Settings
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  extensions = { file_browser = { hidden = true } },
})
require("telescope").load_extension("file_browser")

-- Comprehensive list menu for Telescope functionalities
local telescope_options = {
  ["1. Git Commits"] = function() vim.cmd("Telescope git_commits") end,
  ["2. Git Status"] = function() vim.cmd("Telescope git_status") end
}
local telescope_option_names = {}
local n = 0
for i, _ in pairs(telescope_options) do
  n = n + 1
  telescope_option_names[n] = i
end
table.sort(telescope_option_names)
function THEOVIM_TELESCOPE_MENU()
  vim.ui.select(telescope_option_names, {
    prompt = "Telescope option to open",
  },
    function(choice)
      local action_func = telescope_options[choice]
      if action_func ~= nil then
        action_func()
      end
    end)
end

-- }}}
