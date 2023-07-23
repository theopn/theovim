--[[
Cat: https://www.asciiart.eu/animals/cats
     I added a few layers of belly so it looks more like my cat Oliver

     \/       \/
     /\_______/\
    /   o   o   \
   (  ==  ^  ==  )
    )           (
   (             )
   ( (  )   (  ) )
  (__(__)___(__)__)
 ___
  | |_  _  _     o __
  | | |(/_(_)\_/ | |||

--]]

-- Core config modules
require("core")
require("plugins")

-- UI
require("ui.statusline").setup()
require("ui.dashboard").setup()

-- LSP configurations
require("lsp.lsp")
require("lsp.completion")

-- Plugin configurations
require("config.treesitter")
require("config.fuzzy")

---[[ Theovim Functions
require("misc")
--]]

---[[ Safeguards around including user configuration file
local status, _ = pcall(require, "config")
if (not status) then return end
--]]

local function wordle()
  -- window size and pos
  local win_height = math.ceil(vim.o.lines * 0.3)
  local win_width = math.ceil(vim.o.columns * 0.5)
  local x_pos = math.ceil((vim.o.lines - win_height) * 0.5)  --> Center
  local y_pos = math.ceil((vim.o.columns - win_width) * 0.5) --> Center

  local win_opts = {
    border = "rounded", --> sigle, double, rounded, solid, shadow
    relative = "editor",
    style = "minimal",  --> No number, cursorline, etc.
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
  }

  -- create preview buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") --> Kill the buffer when hidden
  vim.api.nvim_win_set_option(win, "winblend", 50)      --> 0 for solid color, 80 for transparent

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)
  vim.keymap.set('n', "<ESC>", "<C-w>q", keymaps_opts)

  -- command
  local cmd = "python3 ~/Downloads/wordle.py"
  vim.fn.termopen(cmd)
end

vim.api.nvim_create_user_command("Wordle", wordle, { nargs = 0 })
