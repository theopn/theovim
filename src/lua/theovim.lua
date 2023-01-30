--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

-- Reference: https://github.com/ellisonleao/glow.nvim/blob/main/lua/glow/init.lua
local function theovimHelpWindowOpen()
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
  vim.api.nvim_win_set_option(win, "winblend", 0)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "theovimHelp")

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set("n", "q", "<C-w>q", keymaps_opts)
  vim.keymap.set("n", "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  vim.api.nvim_buf_set_option(0, "modifiable", true)
  local file_path = vim.api.nvim_get_runtime_file("theovim-help-doc.md", false)[1]
  vim.api.nvim_command("$read" .. file_path)
  vim.api.nvim_buf_set_option(0, "modifiable", false)

end


vim.api.nvim_create_user_command("TheovimUpdate", function()
  vim.api.nvim_command(":! cd ~/.theovim && git pull && ./theovim-util.sh update")
  require('lazy').update()
end, { nargs = 0 })

vim.api.nvim_create_user_command("TheovimHelp", theovimHelpWindowOpen, { nargs = 0 })

vim.api.nvim_create_user_command("TheovimInfo", function()
  print("Coming soon! Look for GitHub update and use :TheovimUpdate often!")
end, { nargs = 0 })
