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
-- set ttyfast smarttab wildmenu
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
  laststatus     = 3,     --> 0: never, 1: >= 2 windows, 2: always, 3: always and have one global statusline

  -- Char rendering
  list           = true, --> Render special char in listchars
  listchars      = { tab = "⇥ ", leadmultispace = "┊ ", trail = "␣", nbsp = "⍽" },
  showbreak      = "↪", --> Render beginning of wrapped lines
  breakindent    = true, --> Wrapped line will have the same indentation level as the beginning of the line

  -- Spell
  spelllang      = "en",
  spellsuggest   = "best,8", --> Suggest 8 words for spell suggestion
  spell          = false,    --> autocmd will enable spellcheck in Tex or markdown

  -- Fold
  foldmethod     = "expr",                       --> Use `foldexpr` function for folding
  foldexpr       = "nvim_treesitter#foldexpr()", --> Treesitter folding
  --foldlevel      = 1,                         --> Ignored when expr, but when folding by "marker", it only folds folds w/in a fold only
  --foldenable     = false,                     --> True for "marker" + level = 1, false for TS folding

  -- Others
  mouse          = "a",
  confirm        = true, --> Confirm before exiting with unsaved bufffer(s)
  --autochdir      = true, --> Change the CWD whenever you open a file, switch buffers ,etc.
}

local opt = vim.opt
for key, val in pairs(my_opt) do
  opt[key] = val
end

--------------------------------------------------------- CMD  ---------------------------------------------------------

--[[ trim_whitespace()
  -- Vimscript-based function to trim trailing whitespaces
  -- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning when no match found, c: confirm
  --]]
local function trim_whitespace()
  local win_save = vim.fn.winsaveview()
  vim.cmd("keeppatterns %s/\\s\\+$//ec")
  vim.fn.winrestview(win_save)
end
vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace,
  { nargs = 0 })

-- Show the changes made since the last write
vim.api.nvim_create_user_command("ShowChanges", ":w !diff % -",
  { nargs = 0 })

-- Change curr window local dir to the parent dir of curr file
vim.api.nvim_create_user_command("CD", ":lcd %:h",
  { nargs = 0 })


------------------------------------------------------- AUTOCMD --------------------------------------------------------

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- Spell check in relevant buffer filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "tex", "text" },
  callback = function() vim.opt_local.spell = true end
})

-- {{{ File settings based on ft
-- Dictionary for supported file type (key) and the table containing values (values)
local ft_style_vals = {
  ["c"] = { colorcolumn = "80", tabwidth = 2 },
  ["cpp"] = { colorcolumn = "80", tabwidth = 2 },
  ["python"] = { colorcolumn = "80", tabwidth = 4 },
  ["java"] = { colorcolumn = "120", tabwidth = 4 },
  ["lua"] = { colorcolumn = "120", tabwidth = 2 },
}
-- Make an array of the supported file type
local ft_names = {}
local n = 0
for i, _ in pairs(ft_style_vals) do
  n = n + 1
  ft_names[n] = i
end
-- Using the array and dictionary, make autocmd for the supported ft
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FileSettings", { clear = true }),
  pattern = ft_names,
  callback = function()
    vim.opt_local.colorcolumn = ft_style_vals[vim.bo.filetype].colorcolumn
    vim.opt_local.shiftwidth = ft_style_vals[vim.bo.filetype].tabwidth
    vim.opt_local.tabstop = ft_style_vals[vim.bo.filetype].tabwidth
  end
})
-- }}}

-- {{{ Terminal autocmd
-- Switch to insert mode when terminal is open
local term_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = term_augroup,
  pattern = "term://*", --> only applicable for "BufEnter", an ignored Lua table key when evaluating TermOpen
  callback = function() vim.cmd("startinsert") end
})

-- Automatically close terminal unless exit code isn't 0
vim.api.nvim_create_autocmd("TermClose", {
  group = term_augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
      vim.notify_once("Previous terminal job was successful!")
    else
      vim.notify_once("Error code detected in the current terminal job!")
    end
  end
})
-- }}}

-------------------------------------------------------- KEYMAP --------------------------------------------------------

-- Space as the leader --
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, noremap = true }) --> Unbind space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--[[ url_handler()
-- Find the URL in the current line and open it in a browser if possible
-- @requires macOS open command or Linux xdg-open
--]]
local function url_handler()
  -- <something>://<something that aren't >,;")>
  local url = string.match(vim.fn.getline("."), "[a-z]*://[^ >,;)\"']*")
  if url ~= nil then
    -- If URL is found, determine the open command to use
    local cmd = nil
    local sysname = vim.loop.os_uname().sysname
    if sysname == "Darwin" then --> or use vim.fn.has("mac" or "linux", etc.)
      cmd = "open"
    elseif sysname == "Linux" then
      cmd = "xdg-open"
    end
    -- Open the URL using exec
    if cmd then
      vim.cmd('exec "!' .. cmd .. " '" .. url .. "'" .. '"') --> exec "!open 'foo://bar baz'"
    end
  else
    vim.notify("No URI found in the current line")
  end
end

--[[ smarter_win_nav()
-- Move to a window (one of hjkl) or create a split if a window does not exist in the direction
-- Lua translation of:
-- https://www.reddit.com/r/vim/comments/166a3ij/comment/jyivcnl/?utm_source=share&utm_medium=web2x&context=3
-- Usage: vim.keymap("n", "<C-h>", function() move_or_create_win("h") end, {})
--
-- @arg key: One of h, j, k, l, a direction to move or create a split
--]]
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

    vim.cmd("wincmd " .. key)
  end
end

-- {{{ Keybinding table
local key_opt = {
  -- Convenience --
  { "i", "jk",        "<ESC>",        "Better ESC" },
  { "n", "<leader>a", "gg<S-v>G",     "[a]ll: select all" },
  { "n", "gx",        url_handler,    "Open URL under the cursor using shell open command" },

  -- Search --
  { "n", "n",         "nzz",          "Highlight next search and center the screen" },
  { "n", "N",         "Nzz",          "Highlight prev search and center the screen" },
  { "n", "<leader>/", "<CMD>noh<CR>", "[/]: clear search" },

  -- Copy and paste --
  { "x", "<leader>y", '"+y',          "[y]ank: yank to the system clipboard (+)" },
  {
    "n",
    "<leader>p",
    "<CMD>reg", --> will be overriden in Telescope config
    "[p]aste: choose from a register",
  },
  {
    "x",
    "<leader>p",
    '"_dP', --> First, [d]elete the selection and send content to _ void reg then [P]aste (b4 cursor unlike small p)
    "[p]aste: paste the current selection without overriding the reg",
  },

  -- Terminal --
  { "t", "<ESC>",     "<C-\\><C-n>",        "[ESC]: exit insert mode for the terminal" },
  {
    "n",
    "<leader>z",
    function() --> will be overriden in misc.lua terminal location picker
      vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * (1 / 3)) .. "sp | term")
    end,
    "[z]sh: Launch a terminal below",
  },

  -- Spell check --
  {
    "i",
    "<C-s>",
    "<C-g>u<ESC>[s1z=`]a<C-g>u",
    "[s]pell: fix nearest spelling error and put the cursor back",
  },
  {
    "n",
    "<C-s>",
    "z=",
    "[s]pell: toggle spell suggestion window for the word under the cursor",
  },
  {
    "n",
    "<leader>st",
    "<CMD>set spell!<CR>",
    "[s]pell [t]oggle: turn spell check on/off for the current buffer",
  },

  -- Buffer --
  {
    "n",
    "<leader>b",
    ":ls<CR>:b<SPACE>", --> will be overriden in Telescope config
    "[b]uffer: open the buffer list",
  },
  { "n", "<leader>[", "<CMD>bprevious<CR>", "[[]: navigate to prev buffer" },
  { "n", "<leader>]", "<CMD>bnext<CR>",     "[]]: navigate to next buffer" },
  {
    "n",
    "<leader>k",
    ":ls<CR>:echo '[Theovim] Choose a buf to delete (blank: choose curr buf, RET: confirm, ESC: cancel)'<CR>:bdelete<SPACE>",
    "[k]ill : Choose a buffer to kill",
  },

  -- Window --
  { "n", "<C-h>", function() smarter_win_nav("h") end, "[h]: Move to window on the left or create a split", },
  { "n", "<C-j>", function() smarter_win_nav("j") end, "[j]: Move to window below or create a vertical split", },
  { "n", "<C-k>", function() smarter_win_nav("k") end, "[k]: Move to window above or create a vertical split", },
  { "n", "<C-l>", function() smarter_win_nav("l") end, "[l]: Move to window on the right or create a split", },
  {
    "n",
    "<leader>+",
    "<CMD>exe 'resize ' . (winheight(0) * 3/2)<CR>",
    "[+]: Increase the current window height by one-third",
  },
  {
    "n",
    "<leader>-",
    "<CMD>exe 'resize ' . (winheight(0) * 2/3)<CR>",
    "[-]: Decrease the current window height by one-third",
  },
  {
    "n",
    "<leader>>",
    function()
      local width = math.ceil(vim.api.nvim_win_get_width(0) * 3 / 2)
      vim.cmd("vertical resize " .. width)
    end,
    "[>]: Increase the current window width by one-third",
  },
  {
    "n",
    "<leader><",
    function()
      local width = math.ceil(vim.api.nvim_win_get_width(0) * 2 / 3)
      vim.cmd("vertical resize " .. width)
    end,
    "[<]: Decrease the current window width by one-third",
  },

  -- Tab --
  {
    "n",
    "<leader>t",
    ":ls<CR>:echo '[Theovim] Choose a buf to create a new tab w/ (blank: choose curr buf, RET: confirm, ESC: cancel)'<CR>:tab sb<SPACE>",
    "[t]ab: create a new tab",
  },
  { "n",
    "<leader>q",
    "<CMD>tabclose<CR>",
    "[q]uit: close current tab",
  },
  { "n", "<leader>1", "1gt", "Go to tab 1" },
  { "n", "<leader>2", "2gt", "Go to tab 2" },
  { "n", "<leader>3", "3gt", "Go to tab 3" },
  { "n", "<leader>4", "4gt", "Go to tab 4" },
  { "n", "<leader>5", "5gt", "Go to tab 5" },

  -- LSP --
  {
    "n",
    "<leader>ca",
    function() vim.notify_once("This keybinding requires lsp.lua module") end,
    "[c]ode [a]ction: open the menu to perform LSP features",
  },
}
-- }}}

-- Set keybindings
local keymap = vim.keymap
for _, v in ipairs(key_opt) do
  -- non-recursive mapping, call commands silently
  local opts = { noremap = true, silent = true }
  -- Add optional description to the table if provided
  if v[4] then opts.desc = v[4] end
  -- Set keybinding
  keymap.set(v[1], v[2], v[3], opts)
end
