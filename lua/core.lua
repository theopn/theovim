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

------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- SET: ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- {{{ These are options widely accepted to be the "default" within the Neovim/Vim communities
do
  local unopinionated_opt = {
    { "filetype",      'on' },  --> Detect the type of the file that is edited
    { "syntax",        'on' },  --> Turn the default highlighting on, overriden by Treesitter in supported buffers
    { "confirm",       true },  --> Confirm before exiting with unsaved bufffer(s)
    { "autochdir",     false }, --> When on, Vim will change the CWD whenever you open a file, switch buffers ,etc.
    { "scrolloff",     7 },     --> Keep minimum x number of screen lines above and below the cursor
    { "showtabline",   2 },     --> 0: never, 1: if there are at least two tab pages, 2: always
    { "laststatus",    3 },     --> Similar to showtabline, and in Nvim 0.7, 3 displays one bar for multiple windows
    -- Search --
    { "hlsearch",      true },  --> Highlight search results
    { "incsearch",     true },  --> As you type, match the currently typed workd w/o pressing enter
    { "ignorecase",    true },  --> Ignore case in search
    { "smartcase",     true },  --> /smartcase -> apply ignorecase | /sMartcase -> do not apply ignorecase
    -- Split pane --
    { "splitright",    false }, --> Vertical split default to left
    { "splitbelow",    true },  --> Horizontal split default to below
    { "termguicolors", true },  --> Enables 24-bit RGB color in the TUI
    { "mouse",         'a' },   --> Enable mouse
    { "list",          true },  --> Needed for listchars
    { "listchars",              --> Listing special chars
      { tab = "▷▷", trail = "␣", nbsp = "⍽" } },
    -- Fold --
    { "foldmethod", "expr" }, --> Leave the fold up to treesitter
    { "foldlevel",  1 },      --> Useless with expr, but when folding by "marker", it only folds folds w/in a fold only
    { "foldenable", false },  --> True for "marker" + level = 1, false for TS folding
  }
  -- Folding using TreeSitter --
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  for _, v in ipairs(unopinionated_opt) do
    vim.opt[v[1]] = v[2]
  end
end
-- }}}

-- {{{ These are options that the Theovim author believes to be most optimal for his use -- feel free to change
-- }}}
do
  local edit_opt = {
    { "tabstop",      2 },        --> How many characters Vim /treats/renders/ <TAB> as
    { "softtabstop",  0 },        --> How many chracters the /cursor/ moves with <TAB> and <BS> -- 0 to disable
    { "expandtab",    true },     --> Use space instead of tab
    { "shiftwidth",   2 },        --> Number of spaces to use for auto-indentation, <<, >>, etc.
    { "spelllang",    "en" },     --> Engrish
    { "spellsuggest", "best,8" }, --> Suggest 8 words for spell suggestion
    { "spell",        false },    --> autocmd will enable spellcheck in Tex or markdown
  }
  for _, v in ipairs(edit_opt) do
    vim.opt[v[1]] = v[2]
  end
  -- Trimming extra whitespaces --
  -- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning, no need for <CR> for usercmd
  vim.api.nvim_create_user_command("TrimWhitespace", ":let save=@/<BAR>:%s/\\s\\+$//e<BAR>:let @/=save<BAR>",
    { nargs = 0 })
  -- Show the changes made since the last write
  vim.api.nvim_create_user_command("ShowChanges", ":w !diff % -",
    { nargs = 0 })
  --
  vim.api.nvim_create_user_command("CD", ":lcd %:h",
    { nargs = 0 })
end

do
  local win_opt = {
    { "number",         true }, --> Line number
    { "relativenumber", true },
    { "numberwidth",    3 },    --> Width of the number
    { "cursorline",     true },
    { "cursorcolumn",   true },
  }
  for _, v in pairs(win_opt) do
    vim.opt[v[1]] = v[2]
  end
end
-- }}}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- AUTOCMD --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

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

-- {{{ Spell check in relevant buffer filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "tex", "text" },
  callback = function() vim.opt_local.spell = true end
})
-- }}}

-- {{{ Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})
-- }}}

-- {{{ Switch to insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  pattern = "term://*", --> only applicable for "BufEnter", an ignored Lua table key when evaluating TermOpen
  callback = function() vim.cmd("startinsert") end
})
-- }}}

------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- KEYMAP --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- {{{ Leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true }) --> Unbind space
vim.g.mapleader = " "                                                --> Space as the leader key
-- }}}

-- {{{ Function for selecting buffer
-- @arg action: vim command to do with the given buffer name
local function buffer_selector(custom_prompt, action)
  -- Creating a table of buffers
  -- nvim_exec returns output (non-error, non-shell :!) if output (boolean value) is true, else empty string
  local contents_str = vim.api.nvim_exec("buffers", true)
  local contents_table = {}
  for line in contents_str:gmatch("[^\n]+") do --> Add each new line to a table
    table.insert(contents_table, line)
  end
  -- Prompting user
  vim.ui.select(contents_table,
    {
      prompt = custom_prompt .. '\n' .. "Choose a buffer or enter/q to select the current buffer:",
    },
    function(choice)
      if choice == nil then
        vim.cmd(action)
      else
        local buffer_num = string.match(choice, "%d+") --> get the first number from the buffer list
        vim.cmd(action .. buffer_num)
      end
    end)
end

-- }}}

-- {{{ Keybinding table
local key_opt = {
  -- {{{ Text Edit Keybindings
  -- Insert Mode --
  { 'i', "jk",              "<ESC>" },                                            --> "joke", get it? Ha ha
  -- Normal Mode --
  { 'n', "<leader>/",       "<CMD>let @/=''<CR>",          "Clear last search" }, --> @/ is the macro for the last search
  { 'n', "<leader>a",       "gg<S-v>G",                    "Select [a]ll" },
  -- Search auto center --
  { 'n', "n",               "nzz" },
  { 'n', "N",               "Nzz" },
  -- Copy and paste --
  { 'x', "<leader>y",       '"+y',                         "[y}ank to the system clipboard (+" },
  { 'n', "<leader>p",       "<CMD>Telescope registers<CR>" }, --> Use ":reg" w/o PLUGIN
  -- First, [d]elete the selection without pasting (pasting to the void reg _) then [p]aste the reg content
  { 'x', "<leader>p",       '"_dp',                        "[p]aste the current selection without overriding the reg" },
  -- Terminal Mode --
  { 't', "<ESC>",           "<C-\\><C-n>",                 "[ESC] for terminal" },
  -- Spell check --
  { 'i', "<C-s>",           "<C-g>u<ESC>[s1z=`]a<C-g>u",   "Fix nearest [s]pelling error and put the cursor back" },
  { 'n', "<C-s>",           "z=",                          "Toggle [s]pell suggestion window" },
  { 'n', "<leader>st",      "<CMD>set spell!<CR>",         "[s]pell check [t]oggle" },
  -- Split window --
  { 'n', "<leader>|",       "<CMD>vsplit<CR><C-w>l",       "[|] Create a vertical split window" },
  { 'n', "<leader>-",       "<CMD>split<CR><C-w>j",        "[-] Create a horizontal split window" },
  { 'n', "<leader>q",       "<C-w>q",                      "[q]uit the current window" },
  { 'n', "<leader>h",       "<C-w>h" },
  { 'n', "<leader>j",       "<C-w>j" },
  { 'n', "<leader>k",       "<C-w>k" },
  { 'n', "<leader>l",       "<C-w>l" },
  { 'n', "<leader><LEFT>",  "<C-w>10<" },
  { 'n', "<leader><DOWN>",  "<C-w>5-" },
  { 'n', "<leader><UP>",    "<C-w>5+" },
  { 'n', "<leader><RIGHT>", "<C-w>10>" },
  -- Tab --
  { 'n', "<leader>n",
    function() buffer_selector("Creating a new tab...", "tab sb ") end }, --> ":ls<CR>:echo ...<CR>:tab sb<SPACE> w/o custom func
  { 'n', "<leader>1", "1gt" },                                            --> Go to 1st tab
  { 'n', "<leader>2", "2gt" },                                            --> ^
  { 'n', "<leader>3", "3gt" },                                            --> ^
  { 'n', "<leader>4", "4gt" },                                            --> ^
  -- Buffer --
  { 'n', "<leader>b", "<CMD>Telescope buffers<CR>", "[b]uffer list" },    --> ":ls<CR>:b<SPACE>" W/O PLUGIN
  { 'n', "<leader>[", "<CMD>bprevious<CR>",         "[[] prev buffer" },
  { 'n', "<leader>]", "<CMD>bnext<CR>",             "[]] next buffer" },
  { 'n', "<leader>x",
    function() buffer_selector("Deleting a buffer...", "bdelete ") end }, --> ":ls<CR>:echo ...<CR>:bdelete<SPACE> w/o custom func
  -- }}}

  -- {{{ Plugin/Feature Specific Keybindings
  { 'n', "<leader>?",  "<CMD>Telescope keymaps<CR>" },           --> Bring up finder for keymaps
  { 'n', "<leader>t",  "<CMD>NvimTreeToggle<CR>" },              --> Tree toggle
  -- Custom menus --
  { 'n', "<leader>g",  function() THEOVIM_GIT_MENU() end },      --> Git related features
  { 'n', "<leader>m",  function() THEOVIM_MISC_MENU() end },     --> All the other features
  { 'n', "<leader>z",  function() THEOVIM_TERMINAL_MENU() end }, --> Quick terminal launch
  -- Telescope --
  { 'n', "<leader>ca", function() vim.notify("This keybinding requires fuzzy_finder.lua moduke") end },
  { 'n', "<leader>ff", "<CMD>Telescope find_files<CR>" },
  { 'n', "<leader>fr", "<CMD>Telescope oldfiles<CR>" },
  { 'n', "<leader>fb", "<CMD>Telescope file_browser<CR>" },
  { 'n', "<leader>f/", "<CMD>Telescope current_buffer_fuzzy_find<CR>" },
  -- LSP --
  { 'n', "<leader>ca",
    function() vim.notify("This keybinding requires lsp.lua moduke") end },
  { 'n', "<leader>cd", function() vim.lsp.buf.hover() end,  "([c]ode) view hover [d]oc for the item under the cursor" },
  { 'n', "<leader>cr", function() vim.lsp.buf.rename() end, "([c]ode) [r]ename the variable under the cursor" },
  -- }}}
}
-- }}}

-- Set keybindings
for _, v in ipairs(key_opt) do
  -- non-resucrive mapping, call commands silently
  local opt = { noremap = true, silent = true }
  -- Add optional description to the table if needed
  if v[4] then
    opt.desc = v[4]
  end
  vim.keymap.set(v[1], v[2], v[3], opt)
end