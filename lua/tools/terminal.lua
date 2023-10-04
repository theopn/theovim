--[[
--
--
-- Provides:
-- - Floating terminal
-- - Menu for selecting where to launch terminal
--]]

local M = {}

--[[ create_select_menu()
-- Create a menu to execute a Vim command or Lua function using vim.ui.select()
-- Example usage:
-- local options = {
--   [1. Onedark ] = "colo onedark"
--   [2. Tokyonight ] = function() vim.cmd("colo tokyonight") end
-- }
-- local colo_picker = util.create_select_menu("Choose a colorscheme", options)
-- vim.api.nvim_create_user_command("ColoPicker", colo_picker, { nargs = 0 })
--
-- @arg prompt: the prompt to display
-- @arg options_table: Table of the form { [n. Display name] = lua-function/vim-cmd, ... }
--                    The number is used for the sorting purpose and will be replaced by vim.ui.select() numbering
--]]
M.create_select_menu = function(prompt, options_table)
  -- Given the table of options, populate an array with option display names
  local option_names = {}
  local n = 0
  for i, _ in pairs(options_table) do
    n = n + 1
    option_names[n] = i
  end
  table.sort(option_names)
  -- Return the prompt function. These global function var will be used when assigning keybindings
  local menu = function()
    vim.ui.select(
      option_names,
      {
        prompt = prompt,
        format_item = function(item) return item:gsub("%d. ", "") end
      },
      function(choice)
        local action = options_table[choice]
        if action ~= nil then
          if type(action) == "string" then
            vim.cmd(action)
          elseif type(action) == "function" then
            action()
          end
        end
      end)
  end
  return menu
end

--[[ spawn_floating_term()
-- Create a floating terminal (80% of the current window size)
--
-- @return a function that creates the floating terminal
--]]
M.spawn_floating_term = function()
  local win_height = vim.api.nvim_win_get_height(0) or vim.o.columns
  local win_width = vim.api.nvim_win_get_width(0) or vim.o.lines
  local float_win_height = math.ceil(win_height * 0.8)
  local float_win_width = math.ceil(win_width * 0.8)
  local x_pos = math.ceil((win_width - float_win_width) * 0.5)   --> Centering the window
  local y_pos = math.ceil((win_height - float_win_height) * 0.5) --> Centering the window

  local win_opts = {
    border = "rounded", --> sigle, double, rounded, solid, shadow
    relative = "editor",
    style = "minimal",  --> No number, cursorline, etc.
    width = float_win_width,
    height = float_win_height,
    row = y_pos,
    col = x_pos,
  }

  local float_win = function()
    -- create preview buffer and set local options
    local buf = vim.api.nvim_create_buf(false, true) --> Not add to buffer list (false), scratch buffer (true)
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- options
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") --> Kill the buffer when hidden
    vim.api.nvim_win_set_option(win, "winblend", 24)      --> 0 for solid color, 80 for transparent

    -- keymap
    local keymaps_opts = { silent = true, buffer = buf }
    vim.keymap.set('n', "q", "<C-w>q", keymaps_opts) --> both C-w q or below function are fine
    vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

    -- Open term
    vim.cmd("term")
    vim.cmd("startinsert")

    -- Using following three lines reading the file instead of opening term
    --vim.api.nvim_buf_set_option(0, "modifiable", true)
    --vim.cmd("silent 0r" .. file_path)
    --vim.api.nvim_buf_set_option(0, "modifiable", false)
  end
  return float_win
end

return M
