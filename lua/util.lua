--[[ theovim_util.lua
-- $ figlet -f stampatello theovim
-- .  .
-- |- |-. ,-. ,-. .  , . ,-,-.
-- |  | | |-' | | | /  | | | |
-- `' ' ' `-' `-' `'   ' ' ' '
--
-- Collection of helper functions used by Theovim
--]]
local M = {}

--[[ create_select_menu()
-- Create a menu to execute a Vim command or Lua function using vim.ui.select()
-- Example usage:
-- local options = {
--   [1. Onedark ] = "colo onedark"
--   [2. Tokyonight ] = function() vim.cmd("colo tokyonight") end
-- }
-- create_select_menu("Choose a colorscheme", options)
--
-- @arg prompt: the prompt to display
-- @arg options_table: Table of the form { [1. Display name] = lua-function/vim-cmd, ... }
--                    The number is used for the sorting purpose and will be replaced by vim.ui.select() numbering
--]]
--function M.create_select_menu(prompt, options_table)
M.create_select_menu = function(prompt, options_table)
  -- Given the tabl of options, populate an array with prmpt names
  local option_names = {}
  local n = 0
  for i, _ in pairs(options_table) do
    n = n + 1
    option_names[n] = i
  end
  table.sort(option_names)
  -- Return the prompt function. These global function var will be used when assigning keybindings
  local menu = function()
    vim.ui.select(option_names,
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

--[[ launch_notepad()
-- Launch a small, transparent floating window with a scartch buffer that persists until Neovim closes
--]]
vim.g.notepad_loaded = false
local notepad_buf, notepad_win
function M.launch_notepad()
  if not vim.g.notepad_loaded or not vim.api.nvim_win_is_valid(notepad_win) then
    if not notepad_buf or not vim.api.nvim_buf_is_valid(notepad_buf) then
      -- Create a buffer if it none existed
      notepad_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(notepad_buf, "bufhidden", "hide")
      vim.api.nvim_buf_set_option(notepad_buf, "filetype", "markdown")
      vim.api.nvim_buf_set_lines(notepad_buf, 0, 1, false,
        { "WARNING: Notepad content will be erased when the current Neovim instance closes" })
    end
    -- Create a window
    notepad_win = vim.api.nvim_open_win(notepad_buf, true, {
      border = "rounded",
      relative = "editor",
      style = "minimal",
      height = math.ceil(vim.o.lines * 0.5),
      width = math.ceil(vim.o.columns * 0.5),
      row = 1,                                               --> Top of the window
      col = math.ceil(vim.o.columns * 0.5),                  --> Far right; should add up to 1 with win_width
    })
    vim.api.nvim_win_set_option(notepad_win, "winblend", 30) --> Semi transparent buffer

    -- Keymaps
    local keymaps_opts = { silent = true, buffer = notepad_buf }
    vim.keymap.set('n', "<ESC>", function() M.launch_notepad() end, keymaps_opts)
    vim.keymap.set('n', "q", function() M.launch_notepad() end, keymaps_opts)
  else
    vim.api.nvim_win_hide(notepad_win)
  end
  vim.g.notepad_loaded = not vim.g.notepad_loaded
end

return M
