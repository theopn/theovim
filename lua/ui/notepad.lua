--[[ notepad.lua
-- $ figlet -f nancyj theovim
--   dP   dP                                  oo
--   88   88
-- d8888P 88d888b. .d8888b. .d8888b. dP   .dP dP 88d8b.d8b.
--   88   88'  `88 88ooood8 88'  `88 88   d8' 88 88'`88'`88
--   88   88    88 88.  ... 88.  .88 88 .88'  88 88  88  88
--   dP   dP    dP `88888P' `88888P' 8888P'   dP dP  dP  dP
--
-- This module provides a framework to launch a small,
-- transparent floating window with a scartch buffer that persists until Neovim closes
--]]
M = {}

-- Because these variables belong to module,
-- it is recommended that require("ui.notepad") call only happens once in the entire config
-- Otherwise, you will have multiple scratch buffer with multiple notepad status
M.notepad_loaded = false
M.notepad_buf, M.notepad_win = nil, nil

--[[ launch_notepad()
-- Checkes if notepad window is active first
-- then checkes if notepad buffer has been initialized. If so, reuse the buffer, else, create a new scratch buffer
-- If window is not active, display a small floating window with the scratch buffer
--
-- @requires M.notepad_loaded, M.notepad_buf, M.notepad_win variables in util (this) module
--]]
function M.toggle_notepad()
  if not M.notepad_loaded or not vim.api.nvim_win_is_valid(M.notepad_win) then
    if not M.notepad_buf or not vim.api.nvim_buf_is_valid(M.notepad_buf) then
      -- Create a buffer if it none existed
      M.notepad_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(M.notepad_buf, "bufhidden", "hide")
      vim.api.nvim_buf_set_option(M.notepad_buf, "filetype", "markdown")
      vim.api.nvim_buf_set_lines(M.notepad_buf, 0, 1, false,
        { "# Theovim Notepad",
          "",
          "> Notepad clears when the current Neovim session closes",
        })
    end
    -- Create a window
    M.notepad_win = vim.api.nvim_open_win(M.notepad_buf, true, {
      border = "rounded",
      relative = "editor",
      style = "minimal",
      height = math.ceil(vim.o.lines * 0.5),
      width = math.ceil(vim.o.columns * 0.5),
      row = 1,                                                 --> Top of the window
      col = math.ceil(vim.o.columns * 0.5),                    --> Far right; should add up to 1 with win_width
    })
    vim.api.nvim_win_set_option(M.notepad_win, "winblend", 30) --> Semi transparent buffer

    -- Keymaps
    local keymaps_opts = { silent = true, buffer = M.notepad_buf }
    vim.keymap.set('n', "<ESC>", function() M.toggle_notepad() end, keymaps_opts)
    vim.keymap.set('n', "q", function() M.toggle_notepad() end, keymaps_opts)
  else
    vim.api.nvim_win_hide(M.notepad_win)
  end
  M.notepad_loaded = not M.notepad_loaded
end

--[[ setup()
-- Creates an autocommand to launch the notepad
--]]
M.setup = function()
  vim.api.nvim_create_user_command("Notepad", M.toggle_notepad, { nargs = 0 })
end

return M
