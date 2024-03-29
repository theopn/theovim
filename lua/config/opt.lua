--- config/opt.lua
---
--- $ figlet -f small theovim
---  _   _                _
--- | |_| |_  ___ _____ _(_)_ __
--- |  _| ' \/ -_) _ \ V / | '  \
---  \__|_||_\___\___/\_/|_|_|_|_|
---
--- Initializes options for Neovim
---


-- Options enabled by default in Neovim:
-- filetype syntax on
-- set autoindent autoread background=dark backspace=indent,eol,start nocompatible display=lastline encoding=utf-8
-- set hidden history=10000 nojoinspaces incsearch laststatus=2 ruler showcmd nostartofline tabpagemax=50 timeoutlen=50
-- set ttyfast smarttab wildmenu wildoptions=pum,tagfile
-- https://neovim.io/doc/user/vim_diff.html#nvim-defaults

local opt          = vim.opt

-- Tab
opt.softtabstop    = 0    --> How many chracters the /cursor moves/ with <TAB> and <BS> -- 0 to disable
opt.expandtab      = true --> Use space instead of tab
opt.shiftwidth     = 2    --> Number of spaces to use for auto-indentation, <<, >>, etc.

-- Location in the buffer
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.cursorlineopt  = "number" --> line, screenline, both (i.e., "number,line")
opt.cursorcolumn   = true

-- Search and replace
opt.ignorecase     = true --> Ignore case in search
opt.smartcase      = true --> /smartcase -> apply ignorecase | /sMartcase -> do not apply ignorecase
opt.inccommand     = "split" --> show the substitution in a split window

-- Split
opt.splitright     = true --> Vertical split created right
opt.splitbelow     = true --> Horizontal split created below

-- UI
opt.signcolumn     = "yes" --> Render signcolumn
opt.scrolloff      = 7     --> Keep minimum x number of screen lines above and below the cursor
opt.termguicolors  = true  --> Enables 24-bit RGB color in the TUI
opt.showtabline    = 2     --> 0: never, 1: >= 2 tabs, 2: always
opt.laststatus     = 2     --> 0: never, 1: >= 2 windows, 2: always, 3: always and have one global statusline

-- Char rendering
opt.list           = true --> Render special char in listchars
opt.listchars      = { tab = "⇥ ", trail = "␣", nbsp = "⍽", leadmultispace = "┊ ", }
opt.showbreak      = "↪" --> Render beginning of wrapped lines
opt.breakindent    = true --> Wrapped line will have the same indentation level as the beginning of the line

-- Spell
opt.spell          = false    --> autocmd will enable spellcheck in Tex or markdown
opt.spelllang      = "en"
opt.spellsuggest   = "best,8" --> Suggest 8 words for spell suggestion
opt.spelloptions   = "camel"  --> Consider CamelCase when checking spelling

-- Fold
opt.foldenable     = false                        --> Open all folds until I close them using zc/zC or update using zx
opt.foldmethod     = "expr"                       --> Use `foldexpr` function for folding
opt.foldexpr       = "nvim_treesitter#foldexpr()" --> Treesitter folding
--foldlevel      = 2                            --> Ignore n - 1 level fold

-- Update time
opt.updatetime     = 250
opt.timeoutlen     = 300

-- Others
opt.mouse          = "a"
opt.confirm        = true --> Confirm before exiting with unsaved bufffer(s)
