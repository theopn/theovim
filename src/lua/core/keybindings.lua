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
  { 'i', "jk",              "<ESC><CMD>update<CR>" }, --> "joke", get it? Ha ha
  -- Navigation in insert mode --
  { 'i', "<C-h>",           "<LEFT>" },
  { 'i', "<C-j>",           "<DOWN>" },
  { 'i', "<C-k>",           "<UP>" },
  { 'i', "<C-l>",           "<RIGHT>" },
  -- Normal Mode --
  { 'n', "<leader>/",       "<CMD>let @/=''<CR>" }, --> @/ is the macro for the last search
  { 'n', "<leader>a",       "gg<S-v>G" }, --> Select all
  -- Search auto center --
  { 'n', "n",               "nzz" },
  { 'n', "N",               "Nzz" },
  -- Copy and paste --
  { 'v', "<leader>y",       '"+y' }, --> Copy to the system clipboard
  { 'n', "<leader>p",       "<CMD>Telescope registers<CR>" }, --> ":reg" W/O PLUGIN
  -- Terminal Mode --
  { 't', "<ESC>",           "<C-\\><C-n>" }, --> ESC for term
  -- Spell check --
  { 'i', "<C-s>",           "<C-g>u<ESC>[s1z=`]a<C-g>u" }, --> Fix nearest spelling error and put the cursor back
  { 'n', "<C-s>",           "z=" }, --> Toggle spelling suggestions
  { 'n', "<leader>st",      "<CMD>set spell!<CR>" }, --> Toggle spellcheck
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
  -- Tab --
  { 'n', "<leader>n",       function() buffer_selector("Creating a new tab...", "tab sb ") end }, --> ":ls<CR>:echo ...<CR>:tab sb<SPACE> w/o custom func
  { 'n', "<leader>1",       "1gt" }, --> Go to 1st tab
  { 'n', "<leader>2",       "2gt" }, --> ^
  { 'n', "<leader>3",       "3gt" }, --> ^
  { 'n', "<leader>4",       "4gt" }, --> ^
  { 'n', "<leader>5",       "5gt" }, --> ^
  { 'n', "<leader>6",       "6gt" }, --> ^
  { 'n', "<leader>7",       "7gt" }, --> ^
  { 'n', "<leader>8",       "8gt" }, --> ^
  { 'n', "<leader>9",       "9gt" }, --> ^
  { 'n', "<leader>0",       "10gt" }, --> ^
  -- Buffer --
  { 'n', "<leader>b",       "<CMD>Telescope buffers<CR>" }, --> ":ls<CR>:b<SPACE>" W/O PLUGIN
  { 'n', "<leader>,",       "<CMD>bprevious<CR>" }, --> Cycle through the buffer
  { 'n', "<leader>.",       "<CMD>bnext<CR>" }, --> ^
  { 'n', "<leader>x",       function() buffer_selector("Deleting a buffer...", "bdelete ") end }, --> ":ls<CR>:echo ...<CR>:bdelete<SPACE> w/o custom func
  -- }}}

  -- {{{ Plugin/Feature Specific Keybindings
  { 'n', "<leader>?",       "<CMD>WhichKey<CR>" }, --> Bring up Which-key pop-up
  { 'n', "<leader>t",       "<CMD>NvimTreeToggle<CR>" }, --> Tree toggle
  -- Custom menus --
  { 'n', "<leader>g",       function() THEOVIM_GIT_MENU() end }, --> Git related features
  { 'n', "<leader>m",       function() THEOVIM_MISC_MENU() end }, --> All the other features
  { 'n', "<leader>z",       function() THEOVIM_TERMINAL_MENU() end }, --> Quick terminal launch
  -- Telescope --
  { 'n', "<leader>fa",      function() THEOVIM_TELESCOPE_MENU() end },
  { 'n', "<leader>ff",      "<CMD>Telescope find_files<CR>" },
  { 'n', "<leader>fr",      "<CMD>Telescope oldfiles<CR>" },
  { 'n', "<leader>fb",      "<CMD>Telescope file_browser<CR>" },
  { 'n', "<leader>f/",      "<CMD>Telescope current_buffer_fuzzy_find<CR>" },
  -- LSP --
  { 'n', "<leader>ca",      function() THEOVIM_LSP_MENU() end },
  { 'n', "<leader>cd",      function() vim.lsp.buf.hover() end }, --> LSPSage requires markdown treesitter
  { 'n', "<leader>cr",      function() require("lspsaga.rename"):lsp_rename() end }, --> vim.lsp.buf.rename()
  -- }}}
}
-- }}}

-- Set keybindings
for _, v in ipairs(key_opt) do
  vim_map(v[1], v[2], v[3])
end
