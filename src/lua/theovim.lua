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

  local weather_command = "curl 'https://wttr.in/?0T' > /dev/null"
  if location ~= nil then
    weather_command = string.format("curl https://wttr.in/%s'?'0T", location.args)
  end
  vim.fn.termopen(weather_command)
end

-- function() my_func() end: inline function calling my_func(); my_func(): return val; my_func: function itself
-- You need to pass function itself to use the usercommand arguments
vim.api.nvim_create_user_command("Weather", weather_popup, { nargs = '?' }) --> ?: 0 or 1, *: > 0, +: > 1 args

-- Register selector command
-- https://www.reddit.com/r/neovim/comments/toke93/how_get_output_of_vim_command_as_lua_table/
local function get_register_table()
  local contents_str = vim.api.nvim_exec("register", true) -- vim.api.nvim_command_output() works too
  local contents_table = {}
  for line in contents_str:gmatch("[^\n]+") do
    table.insert(contents_table, line)
  end
  table.remove(contents_table, 1) -- remove the table header
  return contents_table
end

-- @arg inputstr in a format <char> "<char> <str>
--      e.g. c "0 I yanked this string before
-- @return table index 1 = clipboard name ("<char>)
--         table index 2 = clipboard content
local function format_register_table(inputstr)
  local contents = {}
  -- %a = all letters
  -- . = all characters
  -- () = captures the matched parts
  -- I got register name to work... I don't know how to get the rest of the string
  for line in inputstr:gmatch("%a. .(.)   (.+)") do
    table.insert(contents, line)
  end
  print(contents[1])
  return contents
end

function THEOVIM_REGISTER_MENU()
  vim.ui.select(get_register_table(), {
      prompt = "Register content to paste at the current cursor:",
  },
      function(choice)
        if choice == nil then return end
        -- Regex: . ". .*
        -- l "" <content-of-the-register>
        local content = format_register_table(choice)
        vim.cmd("put "..content[1])
      end)
end


