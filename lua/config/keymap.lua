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

set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, noremap = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, noremap = true })

set("n", "n", "nzz", { silent = true, noremap = true })
set("n", "N", "Nzz", { silent = true, noremap = true })
set("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true })
set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true })

set("n", "<C-w>+", "<C-w>+<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
set("n", "<C-w>-", "<C-w>-<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
set("n", "<C-w><", "<C-w><<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
set("n", "<C-w>>", "<C-w>><CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })

--- Wrapper around vim.keymap.set for easily setting the desc
---
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param desc string|nil
local map = function(mode, lhs, rhs, desc)
  local opt = { silent = true, noremap = true, }
  opt.desc = desc
  set(mode, lhs, rhs, opt)
end

-- Custom keymaps
map("i", "jk", "<ESC>", "Better ESC")
map("i", "<C-s>", "<C-g>u<ESC>[s1z=`]a<C-g>u", "Fix nearest [S]pelling error and put the cursor back")
map({ "n", "x" }, "<leader>a", "gg<S-v>G", "Select [A]ll")
map("n", "<leader><CR>", "<CMD>noh<CR>", "[CleaR] search highlights")
map("n",
  "<leader>t",
  function()
    vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * (1 / 3)) .. "sp | term")
  end,
  "Launch a [t]erminal")

-- Copy and paste
map("x", "<leader>y", '"+y', "[Y]ank to the system clipboard (+)")
map("n",
  "<leader>p",
  ":echo '[Theovim] e.g.: :normal \"*p<CR>!'<CR>" .. ':reg<CR>:normal "',
  "[P]aste from one of the registers")
map("x",
  "<leader>p",
  '"_dP', --> [d]elete the selection and send content to _ void reg then [P]aste (b4 cursor unlike small p)
  "[P]aste the current selection without overriding the register")

-- Buffer
map("n", "[b", "<CMD>bprevious<CR>", "Previous buffer")
map("n", "]b", "<CMD>bnext<CR>", "Next buffer")
map("n",
  "<leader>b",
  ":echo '[Theovim] Choose a buffer'<CR>" .. ":ls<CR>" .. ":b<SPACE>",
  "Open [B]uffer list")
map("n",
  "<leader>k",
  ":echo '[Theovim] Choose a buf to delete (blank to choose curr)'<CR>" .. ":ls<CR>" .. ":bdelete<SPACE>",
  "[K]ill a buffer")

-- Window

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

map("n", "<C-h>", function() smarter_win_nav("h") end, "Move to window on the left or create a split")
map("n", "<C-j>", function() smarter_win_nav("j") end, "Move to window below or create a vertical split")
map("n", "<C-k>", function() smarter_win_nav("k") end, "Move to window above or create a vertical split")
map("n", "<C-l>", function() smarter_win_nav("l") end, "Move to window on the right or create a split")
