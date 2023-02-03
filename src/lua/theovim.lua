--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

-- Reference: https://github.com/ellisonleao/glow.nvim/blob/main/lua/glow/init.lua
local function theovim_floating_win_util(file_path)
  local width = vim.o.columns
  local height = vim.o.lines
  local height_ratio = 0.8
  local width_ratio = 0.8
  local win_height = math.ceil(height * height_ratio)
  local win_width = math.ceil(width * width_ratio)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "shadow",
  }

  -- create preview buffer and set local options
  local buf = vim.api.nvim_create_buf(false, true) -- Not add to buffer list (false), scratch buffer (true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- options
  vim.api.nvim_win_set_option(win, "winblend", 0) --> How much does the background color blends in (80 will be black)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") --> Kill the buffer when hidden
  vim.api.nvim_buf_set_option(buf, "filetype", "theovimFloatingWin")

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
  vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  -- https://www.reddit.com/r/neovim/comments/s97tja/opening_an_existing_file_in_a_floating_window/
  vim.api.nvim_buf_set_option(0, "modifiable", true)
  vim.api.nvim_command("$read" .. file_path)
  vim.api.nvim_buf_set_option(0, "modifiable", false)
end

vim.api.nvim_create_user_command("TheovimUpdate", function()
  vim.api.nvim_command(":! cd ~/.theovim && git pull && ./theovim-util.sh update")
  vim.notify("Update complete. Use :TheovimInfo command to see the latest changelog")
  require('lazy').sync()
end, { nargs = 0 })


local helpdoc_path = vim.api.nvim_get_runtime_file("theovim-help-doc.md", false)[1]
vim.api.nvim_create_user_command("TheovimHelp", function() theovim_floating_win_util(helpdoc_path) end, { nargs = 0 })

local info_path = vim.api.nvim_get_runtime_file("theovim-info.txt", false)[1]
vim.api.nvim_create_user_command("TheovimInfo", function() theovim_floating_win_util(info_path) end, { nargs = 0 })


-- Simplified version of https://github.com/ellisonleao/weather.nvim
local function weather_popup(location)
  -- window size and pos
  local win_height = math.ceil(vim.o.lines * 0.6 - 20)
  local win_width = math.ceil(vim.o.columns * 0.3 - 15)
  local x_pos = 1
  local y_pos = vim.o.columns - win_width

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
    border = "single",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_win_set_option(win, "winblend", 0)

  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
  vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  local weather_command = "curl 'https://wttr.in/?0T'"
  if location ~= nil then
    weather_command = string.format("curl https://wttr.in/%s'?'0T", location.args)
  end
  vim.fn.termopen(weather_command)
end

-- In the above user command creation, I passed the return values of function() my_func() end as the command
-- In here I am passing the function as whole, so it can take arguments from the user command
vim.api.nvim_create_user_command("Weather", weather_popup, { nargs = '?' }) --> ?: 0 or 1, *: > 0, +: > 1
