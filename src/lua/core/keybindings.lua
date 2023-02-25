--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]
--

-- Helper function
local function vim_map(mode, shortcut, target)
  vim.keymap.set(mode, shortcut, target, { noremap = true, silent = true })
end

-- {{{ Leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true }) --> Unbind space
vim.g.mapleader = " " --> Space as the leader key
-- }}}

-- {{{ Keybinding table
local key_opt = {
  -- {{{ Text Edit Keybindings
  -- Insert Mode --
  { 'i', "jk",              "<ESC><CMD>update<CR>" }, --> "joke", get it? Ha ha
  -- Navigation in insert mode --
  { 'i', "<C-h>",           "<LEFT>" },
  { 'i', "<C-j>",           "<DOWN>" },
  { 'i', "<C-k>",           "<UP>" },
  { 'i', "<C-l>",           "<RIGHT>" },
  -- Normal Mode --
  { 'n', "<leader>/",       "<CMD>let @/=''<CR>" }, --> @/ is the macro for the last search
  { 'n', "<leader>a",       "gg<S-v>G" }, --> Select all
  -- Split pane --
  { 'n', "<leader>|",       "<CMD>vsplit<CR><C-w>l" },
  { 'n', "<leader>-",       "<CMD>split<CR><C-w>j" },
  { 'n', "<leader>q",       "<C-w>q" },
  { 'n', "<leader>h",       "<C-w>h" },
  { 'n', "<leader>j",       "<C-w>j" },
  { 'n', "<leader>k",       "<C-w>k" },
  { 'n', "<leader>l",       "<C-w>l" },
  { 'n', "<leader><LEFT>",  "<C-w>10<" },
  { 'n', "<leader><DOWN>",  "<C-w>5-" },
  { 'n', "<leader><UP>",    "<C-w>5+" },
  { 'n', "<leader><RIGHT>", "<C-w>10>" },
  -- Buffer naviagation --
  { 'n', "<leader>n",       "<CMD>enew<CR>" }, --> Open a new buffer
  { 'n', "<leader>,",       "<CMD>bprevious<CR>" },
  { 'n', "<leader>.",       "<CMD>bnext<CR>" },
  { 'n', "<leader>x",       "<CMD>bdelete<CR>" }, --> Kill a buffer
  -- Search auto center --
  { 'n', "n",               "nzz" },
  { 'n', "N",               "Nzz" },
  -- Visual Mode --
  { 'v', "<leader>y",       '"+y' }, --> Copy to the system clipboard
  -- Terminal Mode --
  { 't', "<ESC>",           "<C-\\><C-n>" }, --> ESC for term
  -- Spell check --
  { 'i', "<C-s>",           "<C-g>u<ESC>[s1z=`]a<C-g>u" }, --> Fix nearest spelling error and put the cursor back
  { 'n', "<C-s>",           "z=" }, --> Toggle spelling suggestions
  { 'n', "<leader>st",      "<CMD>set spell!<CR>" }, --> Toggle spellcheck
  -- }}}

  -- {{{ Plugin/Feature Specific Keybindings
  { 'n', "<leader>m",       function() THEOVIM_MISC_MENU() end }, --> All the other features
  { 'n', "<leader>z",       function() THEOVIM_TERMINAL_MENU() end }, --> Quick terminal launch
  { 'n', "<leader>?",       "<CMD>WhichKey<CR>" }, --> Bring up Which-key pop-up
  { 'n', "<leader>t",       "<CMD>NvimTreeToggle<CR>" }, --> Tree toggle
  -- Telescope --
  { 'n', "<leader>p",       "<CMD>Telescope registers<CR>" },
  { 'n', "<leader>fa",      function() THEOVIM_TELESCOPE_MENU() end },
  { 'n', "<leader>ff",      "<CMD>Telescope find_files<CR>" },
  { 'n', "<leader>fb",      "<CMD>Telescope file_browser<CR>" },
  { 'n', "<leader>f/",      "<CMD>Telescope current_buffer_fuzzy_find<CR>" },
  -- LSP --
  { 'n', "<leader>ca",      function() THEOVIM_LSP_MENU() end },
  { 'n', "<leader>cd",      function() vim.lsp.buf.hover() end },
  { 'n', "<leader>cr",      function() require("lspsaga.rename"):lsp_rename() end }, --> vim.lsp.buf.rename()
  -- }}}
}
-- }}}

-- Set keybindings
for _, v in ipairs(key_opt) do
  vim_map(v[1], v[2], v[3])
end
