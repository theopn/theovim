--- config/keymap.lua
---
--- $ figlet -f small theovim
---  _   _                _
--- | |_| |_  ___ _____ _(_)_ __
--- |  _| ' \/ -_) _ \ V / | '  \
---  \__|_||_\___\___/\_/|_|_|_|_|
---
--- Non-plugin keymaps
---

local set = vim.keymap.set

-- Space as the leader
set({ "n", "v" }, "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Default overrides
set("n", "<ESC>", "<CMD>nohlsearch<CR>")
set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

set("n", "n", "nzz")
set("n", "N", "Nzz")
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")

set("n", "<C-w>+", "<C-w>+<CMD>call feedkeys('<C-w>')<CR>", { desc = "Increase the window height (press + to repeat)" })
set("n", "<C-w>-", "<C-w>-<CMD>call feedkeys('<C-w>')<CR>", { desc = "Decrease the window height (press - to repeat)" })
set("n", "<C-w>>", "<C-w>><CMD>call feedkeys('<C-w>')<CR>", { desc = "Increase the window width (press > to repeat)" })
set("n", "<C-w><", "<C-w><<CMD>call feedkeys('<C-w>')<CR>", { desc = "Decrease the window width (press < to repeat)" })

-- Custom keymaps
set("i", "jk", "<ESC>", { desc = "Better ESC" })
set("i", "<C-s>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { desc = "Fix nearest [S]pelling error and put the cursor back" })

-- Copy and paste
set({ "n", "x" }, "<leader>a", "gg<S-v>G", { desc = "Select [A]ll" })
set("x", "<leader>y", '"+y', { desc = "[Y]ank to the system clipboard (+)" })
set("n",
  "<leader>p",
  ":echo '[Theovim] e.g.: `:normal \"3p` to paste the content of the register 3'<CR>" .. ':reg<CR>:normal "',
  { silent = true, desc = "[P]aste from one of the registers" })
set("x",
  "<leader>p",
  '"_dP', --> [d]elete the selection and send content to _ void reg then [P]aste (b4 cursor unlike small p)
  { desc = "[P]aste the current selection without overriding the register" })

-- Buffer
set("n", "[b", "<CMD>bprevious<CR>", { desc = "Go to previous [B]uffer" })
set("n", "]b", "<CMD>bnext<CR>", { desc = "Go to next [B]uffer" })
set("n",
  "<leader>b",
  ":echo '[Theovim] Choose a buffer'<CR>" .. ":ls<CR>" .. ":b<SPACE>",
  { silent = true, desc = "Open [B]uffer list" })
set("n",
  "<leader>k",
  ":echo '[Theovim] Choose a buf to delete (blank to choose curr)'<CR>" .. ":ls<CR>" .. ":bdelete<SPACE>",
  { silent = true, desc = "[K]ill a buffer" })

-- Terminal
-- [[
-- https://medium.com/@egzvor/vim-splits-cheat-sheet-2bf84fc99962
--           | :top sp |
-- |:top vs| |:abo| cu | |:bot vs |
-- |       | |:bel| rr | |        |
--           | :bot sp |
-- botright == bot
-- ]]
set("n",
  "<leader>tb",
  function()
    vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * (1 / 3)) .. "sp | term")
  end,
  { desc = "Launch a [t]erminal in the [B]ottom" })

set("n",
  "<leader>tr",
  function()
    vim.cmd("bot " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term")
  end,
  { desc = "Launch a [t]erminal to the [R]ight" })

set("n",
  "<leader>tt",
  function()
    vim.cmd("tabnew | term")
  end,
  { desc = "Launch a [t]erminal in a new [T]ab" })

--- Move to a window (one of hjkl) or create a split if a window does not exist in the direction.
--- Lua translation of:
--- https://www.reddit.com/r/vim/comments/166a3ij/comment/jyivcnl/?utm_source=share&utm_medium=web2x&context=3
--- Usage: vim.keymap("n", "<C-h>", function() move_or_create_win("h") end, {})
--
---@param key string One of h, j, k, l, a direction to move or create a split
local function smarter_win_nav(key)
  local fn = vim.fn
  local curr_win = fn.winnr()
  vim.cmd("wincmd " .. key)        --> attempt to move

  if (curr_win == fn.winnr()) then --> didn't move, so create a split
    if key == "h" or key == "l" then
      vim.cmd("wincmd v")
    else
      vim.cmd("wincmd s")
    end

    vim.cmd("wincmd " .. key) --> move again
  end
end

set("n", "<C-h>", function() smarter_win_nav("h") end,
  { desc = "Move focus to the left window or create a horizontal split" })
set("n", "<C-j>", function() smarter_win_nav("j") end,
  { desc = "Move focus to the lower window or create a vertical split" })
set("n", "<C-k>", function() smarter_win_nav("k") end,
  { desc = "Move focus to the upper window or create a vertical split" })
set("n", "<C-l>", function() smarter_win_nav("l") end,
  { desc = "Move focus to the right window or create a horizontal split" })
