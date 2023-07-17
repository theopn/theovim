--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

local util = require("util")

--[[ Notes on different exec commands
-- vim.api.nvim_cmd(command):
--   if type(command) == 'table' then return vim.api.nvim_cmd(command, {})
--   else return vim.api.nvim_exec(command, false) end
-- vim.api.nvim_cmd({command}. {opts}): I honestly do not know, it just takes table instead of string
-- vim.api.nvim_exec(command, output?): Executes a Vimscript command and if the output is true, return the result
--   -- From keybindings.lua, captures the output of "buffers" and assign returned string to a var
--   local contents_str = vim.api.nvim_exec("buffers", true)
--
-- vim.api.nvim_command(command): Old API that calls C function for Ex command. Use nvim_cmd
-- vim.api.nvim_command_output(command): Old API, use nvim_exec
--]]
--

-- {{{ Update command
-- Inspiration from: https://github.com/ellisonleao/weather.nvim
local function theovim_update()
  -- window size and pos
  local win_height = math.ceil(vim.o.lines * 0.3)
  local win_width = math.ceil(vim.o.columns * 0.5)
  local x_pos = 1                                            --> Top
  local y_pos = math.ceil((vim.o.columns - win_width) * 0.5) --> Centering the window

  local win_opts = {
    border = "shadow", --> sigle, double, rounded, solid, shadow
    relative = "editor",
    style = "minimal", --> No number, cursorline, etc.
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
  }

  -- create preview buffer and set local options
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") --> Kill the buffer when hidden
  vim.api.nvim_win_set_option(win, "winblend", 50)      --> 0 for solid color, 80 for transparent

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
  vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  -- Executing commands
  local update_command = "cd ~/.theovim && ./theovim-util.sh update"
  update_command = update_command .. " && echo -e '\nUpdate completed! Please restart Theovim :)\n'"
  vim.fn.termopen(update_command)

  require("lazy").sync()
  --vim.cmd("MasonUpdate")
  --vim.cmd("TSUpdate")
  vim.notify("Update complete, please restart Theovim! Use :TheovimInfo command for the changelog :)")
end

-- nargs ?: 0 or 1, *: > 0, +: > 1 args
vim.api.nvim_create_user_command("TheovimUpdate", function() theovim_update() end, { nargs = 0 })
-- }}}

-- {{{ Util commands
-- Reference: https://github.com/ellisonleao/glow.nvim/blob/main/lua/glow/init.lua
local function spawn_floating_help_win(file_path)
  local win_height = math.ceil(vim.o.lines * 0.8)
  local win_width = math.ceil(vim.o.columns * 0.8)
  local x_pos = math.ceil((vim.o.lines - win_height) * 0.5)  --> Centering the window
  local y_pos = math.ceil((vim.o.columns - win_width) * 0.5) --> Centering the window

  local win_opts = {
    border = "rounded", --> sigle, double, rounded, solid, shadow
    relative = "editor",
    style = "minimal",  --> No number, cursorline, etc.
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
  }

  -- create preview buffer and set local options
  local buf = vim.api.nvim_create_buf(false, true) --> Not add to buffer list (false), scratch buffer (true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")    --> Kill the buffer when hidden
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown") --> Markdown syntax highlighting
  vim.opt_local.spell = false                              --> Diable spell check, spell is not a buffer option so this
  vim.api.nvim_win_set_option(win, "winblend", 0)          --> 0 for solid color, 80 for transparent

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
  vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  -- Reading the file
  -- https://www.reddit.com/r/neovim/comments/s97tja/opening_an_existing_file_in_a_floating_window/
  vim.api.nvim_buf_set_option(0, "modifiable", true)
  vim.cmd("silent 0r" .. file_path)
  vim.api.nvim_buf_set_option(0, "modifiable", false)
end

local helpdoc_path = vim.api.nvim_get_runtime_file("theovim-docs/theovim-help.md", false)[1] --> Lua... no 0 indexing
vim.api.nvim_create_user_command("TheovimHelp", function() spawn_floating_help_win(helpdoc_path) end, { nargs = 0 })

local vimhelp_path = vim.api.nvim_get_runtime_file("theovim-docs/vim-help.md", false)[1]
vim.api.nvim_create_user_command("TheovimVanillaVimHelp", function() spawn_floating_help_win(vimhelp_path) end,
  { nargs = 0 })

local info_path = vim.api.nvim_get_runtime_file("theovim-docs/theovim-info.md", false)[1]
vim.api.nvim_create_user_command("TheovimInfo", function() spawn_floating_help_win(info_path) end, { nargs = 0 })
-- }}}

-- {{{ Notepad
-- Inspiration: https://github.com/tamton-aquib/stuff.nvim
vim.api.nvim_create_user_command("Notepad", util.launch_notepad, { nargs = 0 })
-- }}}