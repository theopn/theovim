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
    { "filetype",      'on' },
    { "syntax",        'on' },
    { "scrolloff",     7 }, --> Keep at least 7 lines visible above and below the cursor
    { "hlsearch",      true }, --> Highlight search result
    { "incsearch",     true }, --> Should be enabled by default
    { "ignorecase",    true }, --> Needed for smartcase
    { "smartcase",     true }, --> Ignore case iff search input was all lowercase
    { "splitright",    false }, --> Vertical split default to left
    { "splitbelow",    true }, --> Horizontal split default to below
    { "termguicolors", true },
    { "mouse",         'a' }, --> Enable mouse
    { "list",          true }, --> Needed for listchars
    { "foldmethod",    "expr" }, --> Leave the fold up to treesitter
    { "foldlevel",     1 }, --> Useless with expr, but when folding by "marker", it only folds folds w/in a fold only
    { "foldenable",    false }, --> True for "marker" + level = 1, false for TS folding
  }
  -- Listing special characters --
  vim.opt.listchars = { tab = "t>", trail = "␣", nbsp = "⍽" }
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
    { "shiftwidth",   2 }, --> Indentation width
    { "tabstop",      2 }, --> Backslash t width
    { "softtabstop",  2 }, --> Tab key width
    { "expandtab",    true }, --> Tab as spaces
    { "spelllang",    "en" },
    { "spellsuggest", "best,8" },
    { "spell",        "false" }, --> autocmd will enable spellcheck in txt or markdown
  }
  for _, v in ipairs(edit_opt) do
    vim_set(v[1], GLOBAL, v[2])
  end
  -- Trimming extra whitespaces --
  -- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning, no need for <CR> for usercmd
  vim.api.nvim_create_user_command("TrimWhitespace", ":let save=@/<BAR>:%s/\\s\\+$//e<BAR>:let @/=save<BAR>",
    { nargs = 0 })
end
-- }}}

-- {{{ Window options
do
  local win_opt = {
    { opt = "number",         val = true },
    { opt = "relativenumber", val = true },
    { opt = "colorcolumn",    val = '120' },
    { opt = "cursorline",     val = true },
    { opt = "cursorcolumn",   val = true },
  }
  for _, v in pairs(win_opt) do
    vim_set(v.opt, WINDOW, v.val)
  end
end
-- }}}
