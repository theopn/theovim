--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]

-- {{{ Functions for easier setting
local GLOBAL = vim.o
local WINDOW = vim.wo
local BUFFER = vim.bo
local function vim_set(opt, scope, val)
  scope[opt] = val
end

-- vim.api.nvim_set_keymap is old way of doing it
local function vim_map(mode, shortcut, target)
  vim.keymap.set(mode, shortcut, target, { noremap = true, silent = true })
end

-- }}}

-- {{{ Syntax Related Settings
do
  local syntax_opt = {
    { "filetype", 'on' },
    { "scrolloff", 7 }, --> Keep at least 7 lines visible above and below the cursor
    { "hlsearch", true }, --> Highlight search result
    { "incsearch", true }, --> Should be enabled by default
    { "ignorecase", true }, --> Needed for smartcase
    { "smartcase", true }, --> Ignore case iff search input was all lowercase
    { "foldmethod", "marker" },
    { "foldlevel", 1 },
    { "foldenable", true }, --> Fold enabled w/o hitting zc.
    { "list", true }, --> Needed for listchars
    { "splitright", false }, --> Vertical split default to left
    { "splitbelow", false },
    { "termguicolors", true },
  }
  for _, v in ipairs(syntax_opt) do
    vim_set(v[1], GLOBAL, v[2])
  end
end
-- Trailing white space --
vim.opt.listchars = { tab = "!>", trail = "␣", nbsp = "+" }
-- Highlight on yank --
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})
-- }}}

-- {{{ Text Edit Related Settings
do
  local edit_opt = {
    { "shiftwidth", 2 }, --> Indentation width
    { "tabstop", 2 }, --> Backslash t width
    { "softtabstop", 2 }, --> Tab key width
    { "expandtab", true }, --> Tab as spaces
    { "mouse", 'a' },
    { "spelllang", "en" },
    { "spellsuggest", "best,8" },
  }
  for _, v in ipairs(edit_opt) do
    vim_set(v[1], GLOBAL, v[2])
  end
end
-- Spell check in markdown buffer only --
vim.api.nvim_create_autocmd('FileType', {
  pattern = "markdown",
  callback = function()
    vim.wo.spell = true
  end
}
)
-- }}}

-- {{{ Visual Related Settings
do
  local vis_opt = {
    { opt = "number", val = true },
    { opt = "relativenumber", val = true },
    { opt = "colorcolumn", val = '120' },
    { opt = "cursorline", val = true },
    { opt = "cursorcolumn", val = true },
  }
  for i, v in pairs(vis_opt) do
    vim_set(v.opt, WINDOW, v.val)
  end
end
-- }}}

-- {{{ Key Binding Related Settings
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true }) --> Unbind space
vim.g.mapleader = " " --> Space as the leader key
do
  local key_opt = {
    -- {{{ Text Edit Keybindings
    -- Insert Mode --
    { 'i', "jk", "<ESC><CMD>update<CR>" }, --> "joke", get it? Ha ha
    -- Navigation in insert mode --
    { 'i', "<C-h>", "<LEFT>" },
    { 'i', "<C-j>", "<DOWN>" },
    { 'i', "<C-k>", "<UP>" },
    { 'i', "<C-l>", "<RIGHT>" },
    -- Normal Mode --
    { 'n', "<leader>z", "<CMD>vsplit term://zsh<CR>" }, --> Quick terminal launch
    { 'n', "<leader>/", "<CMD>let @/=''<CR>" }, --> Clear search highlighting
    { 'n', "<leader>a", "gg<S-v>G" }, --> Select all
    -- Split pane navigation and resizing --
    { 'n', "<leader>|", "<CMD>vsplit<CR><C-w>l" },
    { 'n', "<leader>-", "<CMD>split<CR><C-w>j" },
    { 'n', "<leader>h", "<C-w>h" },
    { 'n', "<leader>j", "<C-w>j" },
    { 'n', "<leader>k", "<C-w>k" },
    { 'n', "<leader>l", "<C-w>l" },
    { 'n', "<leader><LEFT>", "<C-w><" },
    { 'n', "<leader><DOWN>", "<C-w>-" },
    { 'n', "<leader><UP>", "<C-w>+" },
    { 'n', "<leader><RIGHT>", "<C-w>>" },
    -- Search auto center --
    { 'n', "n", "nzz" },
    { 'n', "N", "Nzz" },
    -- Visual Mode --
    { 'v', "<leader>y", '"+y' }, --> Copy to the system clipboard
    -- Terminal Mode --
    { 't', "<ESC>", "<C-\\><C-n>" }, --> ESC for term
    -- Spell check --
    { 'i', "<C-s>", "<C-g>u<ESC>[s1z=`]a<C-g>u" }, --> Fix the nearest spelling error and put the cursor back
    { 'n', "<C-s>", "z=" }, --> Toggle spelling suggestions
    { 'n', "<leader>st", "<CMD>set spell!<CR>" }, --> Toggle spellcheck
    -- }}}

    -- {{{ Plugin/Feature Specific Keybindings
    { 'n', "<leader>?", "<CMD>WhichKey<CR>" }, --> Bring up Which-key pop-up
    { 'n', "<leader>n", "<CMD>NvimTreeToggle<CR>" }, --> Tree toggle
    -- Barbar navigation --
    { 'n', "<leader>t", "<CMD>tabnew<CR>" }, --> Open a new buffer
    { 'n', "<leader>,", "<CMD>BufferPrevious<CR>" }, --> Barbar plugin overrides "gT"
    { 'n', "<leader>.", "<CMD>BufferNext<CR>" }, --> Barbar plugin overrides "gt"
    { 'n', "<leader>k", "<CMD>BufferClose<CR>" }, --> Kill a tab
    -- Telescope --
    { 'n', "<leader>fa", function() THEOVIM_TELESCOPE_MENU() end },
    { 'n', "<leader>ff", "<CMD>Telescope find_files<CR>" },
    { 'n', "<leader>fb", "<CMD>Telescope file_browser<CR>" },
    { 'n', "<leader>f/", "<CMD>Telescope current_buffer_fuzzy_find<CR>" }, --> Better search
    -- LSP Related --
    { 'n', "<leader>ca", function() THEOVIM_LSP_MENU() end },
    { 'n', "<leader>cd", function() require("lspsaga.hover"):render_hover_doc() end }, --> vim.lsp.buf.hover()
    { 'n', "<leader>cr", function() require("lspsaga.rename"):lsp_rename() end }, --> vim.lsp.buf.rename()
    -- }}}
  }
  for _, v in ipairs(key_opt) do
    vim_map(v[1], v[2], v[3])
  end
end
-- }}}
