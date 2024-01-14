--[[ core.lua
-- $ figlet -f small theovim
--  _   _                _
-- | |_| |_  ___ _____ _(_)_ __
-- |  _| ' \/ -_) _ \ V / | '  \
--  \__|_||_\___\___/\_/|_|_|_|_|
--
-- Core configuration for Theovim, written only using stock Neovim features and Lua without external plugins or moduels
-- This file alone should provide a sane default Neovim experience (you can rename it as init.lua to use it standalone)
--]]

--------------------------------------------------------- OPT: ---------------------------------------------------------

-- Options enabled by default in Neovim:
-- filetype syntax on
-- set autoindent autoread background=dark backspace=indent,eol,start nocompatible display=lastline encoding=utf-8
-- set hidden history=10000 nojoinspaces incsearch laststatus=2 ruler showcmd nostartofline tabpagemax=50 timeoutlen=50
-- set ttyfast smarttab wildmenu wildoptions=pum,tagfile
-- https://neovim.io/doc/user/vim_diff.html#nvim-defaults

local my_opt = {
  -- Tab
  tabstop        = 4,    --> How many characters Vim /treats/renders/ <TAB> as
  softtabstop    = 0,    --> How many chracters the /cursor moves/ with <TAB> and <BS> -- 0 to disable
  expandtab      = true, --> Use space instead of tab
  shiftwidth     = 2,    --> Number of spaces to use for auto-indentation, <<, >>, etc.

  -- Location in the buffer
  number         = true,
  relativenumber = true,
  cursorline     = true,
  cursorlineopt  = "number",
  cursorcolumn   = true,

  -- Search
  ignorecase     = true, --> Ignore case in search
  smartcase      = true, --> /smartcase -> apply ignorecase | /sMartcase -> do not apply ignorecase

  -- Split
  splitright     = true, --> Vertical split created right
  splitbelow     = true, --> Horizontal split created below

  -- UI
  signcolumn     = "yes", --> Render signcolumn
  scrolloff      = 7,     --> Keep minimum x number of screen lines above and below the cursor
  termguicolors  = true,  --> Enables 24-bit RGB color in the TUI
  showtabline    = 2,     --> 0: never, 1: >= 2 tabs, 2: always
  laststatus     = 2,     --> 0: never, 1: >= 2 windows, 2: always, 3: always and have one global statusline

  -- Char rendering
  list           = true, --> Render special char in listchars
  listchars      = { tab = "⇥ ", leadmultispace = "┊ ", trail = "␣", nbsp = "⍽" },
  showbreak      = "↪", --> Render beginning of wrapped lines
  breakindent    = true, --> Wrapped line will have the same indentation level as the beginning of the line

  -- Spell
  spell          = false,    --> autocmd will enable spellcheck in Tex or markdown
  spelllang      = "en",
  spellsuggest   = "best,8", --> Suggest 8 words for spell suggestion
  spelloptions   = "camel",  --> Consider CamelCase when checking spelling

  -- Fold
  foldenable     = false,                        --> Open all folds until I close them using zc/zC or update using zx
  foldmethod     = "expr",                       --> Use `foldexpr` function for folding
  foldexpr       = "nvim_treesitter#foldexpr()", --> Treesitter folding
  --foldlevel      = 2,                            --> Ignore n - 1 level fold

  -- Update time
  updatetime     = 250,
  timeoutlen     = 300,

  -- Others
  mouse          = "a",
  confirm        = true, --> Confirm before exiting with unsaved bufffer(s)
}

local opt = vim.opt
for key, val in pairs(my_opt) do
  opt[key] = val
end

--------------------------------------------------------- CMD  ---------------------------------------------------------

--- Trims trailing whitespace
--- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning when no match found, c: confirm
local function trim_whitespace()
  local win_save = vim.fn.winsaveview()
  vim.cmd("keeppatterns %s/\\s\\+$//ec")
  vim.fn.winrestview(win_save)
end
vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, { nargs = 0 })

-- Changing current working directory
vim.api.nvim_create_user_command("CD", ":lcd %:h", { nargs = 0 })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- Switch to insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  pattern = "term://*", --> only applicable for "BufEnter", an ignored Lua table key when evaluating TermOpen
  callback = function() vim.cmd("startinsert") end
})

-- Update indentation guide dynamically
local update_leadmultispace_group = vim.api.nvim_create_augroup("UpdateLeadmultispace", { clear = true })

--- Dynamically adjust `leadmultispace` in `listchars` (buffer level) based on `shiftwidth`
local function update_leadmultispace()
  local lead = "┊"
  for _ = 1, vim.bo.shiftwidth - 1 do
    lead = lead .. " "
  end
  vim.opt_local.listchars:append({ leadmultispace = lead })
end

-- When `shiftwidth` was manually changed
vim.api.nvim_create_autocmd("OptionSet", {
  group = update_leadmultispace_group,
  pattern = { "shiftwidth", "filetype" },
  callback = update_leadmultispace,
})

-- WHen shiftwidth has changed by ftplugin
vim.api.nvim_create_autocmd("BufEnter", {
  group = update_leadmultispace_group,
  pattern = "*",
  callback = update_leadmultispace,
  --once = true,
})

-------------------------------------------------------- KEYMAP --------------------------------------------------------

-- Space as the leader --
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Default overrides
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { silent = true, noremap = true })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, noremap = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, noremap = true })

vim.keymap.set("n", "n", "nzz", { silent = true, noremap = true })
vim.keymap.set("n", "N", "Nzz", { silent = true, noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true })

vim.keymap.set("n", "<C-w>+", "<C-w>+<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-w>-", "<C-w>-<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-w><", "<C-w><<CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-w>>", "<C-w>><CMD>call feedkeys('<C-w>')<CR>", { silent = true, noremap = true })

--- Move to a window (one of hjkl) or create a split if a window does not exist in the direction
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

-- Custom keymaps
local key_opt = {
  { "i", "jk",        "<ESC>",        "Better ESC" },
  {
    "i",
    "<C-s>",
    "<C-g>u<ESC>[s1z=`]a<C-g>u",
    "Fix nearest [S]pelling error and put the cursor back",
  },
  { "n", "<leader>a", "gg<S-v>G",     "Select [A]ll" },
  { "n", "<leader><CR>", "<CMD>noh<CR>", "<CleaR> search highlights" },
  {
    "n",
    "<leader>t",
    function() --> will be overriden in misc.lua terminal location picker
      vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * (1 / 3)) .. "sp | term")
    end,
    "Launch a [t]erminal",
  },

  -- Copy and paste --
  { "x", "<leader>y", '"+y',                "[Y]ank to the system clipboard (+)" },
  {
    "n",
    "<leader>p",
    ":echo '[Theovim] e.g.: :normal \"*p<CR>!'<CR>" .. ':reg<CR>:normal "',
    "[P]aste from one of the registers",
  },
  {
    "x",
    "<leader>p",
    '"_dP', --> [d]elete the selection and send content to _ void reg then [P]aste (b4 cursor unlike small p)
    "[P]aste the current selection without overriding the register",
  },

  -- Buffer --
  { "n", "[b",        "<CMD>bprevious<CR>", "Previous buffer" },
  { "n", "]b",        "<CMD>bnext<CR>",     "Next buffer" },
  {
    "n",
    "<leader>b",
    ":echo '[Theovim] Choose a buffer'<CR>" .. ":ls<CR>" .. ":b<SPACE>",
    "Open [B]uffer list",
  },
  {
    "n",
    "<leader>k",
    ":echo '[Theovim] Choose a buf to delete (blank to choose curr)'<CR>"
    .. ":ls<CR>" .. ":bdelete<SPACE>",
    "[K]ill a buffer",
  },

  -- Window --
  { "n", "<C-h>", function() smarter_win_nav("h") end, "Move to window on the left or create a split", },
  { "n", "<C-j>", function() smarter_win_nav("j") end, "Move to window below or create a vertical split", },
  { "n", "<C-k>", function() smarter_win_nav("k") end, "Move to window above or create a vertical split", },
  { "n", "<C-l>", function() smarter_win_nav("l") end, "Move to window on the right or create a split", },
}

-- Set keybindings
for _, v in ipairs(key_opt) do
  -- non-recursive mapping, call commands silently
  local opts = { silent = true, noremap = true }
  -- Add optional description to the table if provided
  if v[4] then opts.desc = v[4] end
  -- Set keybinding
  vim.keymap.set(v[1], v[2], v[3], opts)
end

-------------------------------------------------------- NETRW ---------------------------------------------------------

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 0    --> 0: Simple, 1: Detailed, 2: Thick, 3: Tree
vim.g.netrw_browse_split = 3 --> Open file in 0: Reuse the same win, 1: Horizontal split, 2: Vertical split, 3: New tab
vim.g.netrw_winsize = 25     --> seems to be in percentage

vim.g.netrw_is_open = false
local function toggle_netrw()
  local fn = vim.fn
  if vim.g.netrw_is_open then
    for i = 1, fn.bufnr("$") do
      if fn.getbufvar(i, "&filetype") == "netrw" then
        vim.cmd("bwipeout " .. i)
      end
    end
    vim.g.netrw_is_open = false
  else
    vim.cmd("Lex")
    vim.g.netrw_is_open = true
  end
end
vim.keymap.set("n", "<leader>n", toggle_netrw,
  { silent = true, noremap = true, desc = "Toggle [N]etrw" })
