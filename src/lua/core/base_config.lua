--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]
--

-- {{{ Functions for easier setting
local GLOBAL = vim.o
local WINDOW = vim.wo
local function vim_set(opt, scope, val)
  scope[opt] = val
end
-- }}}

-- {{{ Global base settings
do
  local base_opt = {
    { "filetype",      'on' },   --> Detect what file I'm working on
    { "syntax",        'on' },   --> Syntax highlighting, usually overriden by Treesitter
    { "confirm",       true },
    { "scrolloff",     7 },      --> Keep at least 7 lines visible above and below the cursor
    { "showtabline",   2 },      --> Always show tabline (default 1 - only if there are two or more tabs)
    { "laststatus",    3 },      --> 3 = one statusbar for all win, only available on Neovim 0.7+
    -- Search --
    { "hlsearch",      true },   --> Highlight search result
    { "incsearch",     true },   --> As you type, match the currently typed workd w/o pressing enter
    { "ignorecase",    true },   --> Needed for smartcase
    { "smartcase",     true },   --> Ignore case iff search input was all lowercase
    -- Split pane --
    { "splitright",    false },  --> Vertical split default to left
    { "splitbelow",    true },   --> Horizontal split default to below
    { "termguicolors", true },   --> Enables 24-bit RGB color in the TUI
    { "mouse",         'a' },    --> Enable mouse
    { "list",          true },   --> Needed for listchars
    -- Fold --
    { "foldmethod",    "expr" }, --> Leave the fold up to treesitter
    { "foldlevel",     1 },      --> Useless with expr, but when folding by "marker", it only folds folds w/in a fold only
    { "foldenable",    false },  --> True for "marker" + level = 1, false for TS folding
  }
  -- Listing special characters --
  vim.opt.listchars = { tab = "▷▷", trail = "␣", nbsp = "⍽" }
  -- Folding using TreeSitter --
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  for _, v in ipairs(base_opt) do
    vim_set(v[1], GLOBAL, v[2])
  end
end
-- }}}

-- {{{ Opinionated text editing settings
do
  local edit_opt = {
    { "shiftwidth",   2 },        --> Indentation width, will be overriden in autocmd
    { "tabstop",      2 },        --> Tab display width, ^
    { "softtabstop",  2 },        --> Tab key width    , ^
    { "expandtab",    true },     --> Tab as spaces
    { "spelllang",    "en" },     --> Engrish
    { "spellsuggest", "best,8" }, --> Suggest 8 words for spell suggestion
    { "spell",        "false" },  --> autocmd will enable spellcheck in txt or markdown
  }
  for _, v in ipairs(edit_opt) do
    vim_set(v[1], GLOBAL, v[2])
  end
  -- Trimming extra whitespaces --
  -- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning, no need for <CR> for usercmd
  vim.api.nvim_create_user_command("TrimWhitespace", ":let save=@/<BAR>:%s/\\s\\+$//e<BAR>:let @/=save<BAR>",
    { nargs = 0 })
  -- Show the changes made since the last write
  vim.api.nvim_create_user_command("ShowChanges", ":w !diff % -",
    { nargs = 0 })
  --
end
-- }}}

-- {{{ Window options
do
  local win_opt = {
    { opt = "number",         val = true }, --> Line number
    { opt = "relativenumber", val = true },
    { opt = "numberwidth",    val = 3 },    --> Width of the number
    { opt = "cursorline",     val = true },
    { opt = "cursorcolumn",   val = true },
  }
  for _, v in pairs(win_opt) do
    vim_set(v.opt, WINDOW, v.val)
  end
end
-- }}}
