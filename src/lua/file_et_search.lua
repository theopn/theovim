--[[
" figlet -f small theovim-file,search
"  _   _                _           __ _ _                           _
" | |_| |_  ___ _____ _(_)_ __ ___ / _(_) |___   ___ ___ __ _ _ _ __| |_
" |  _| ' \/ -_) _ \ V / | '  \___|  _| | / -_)_(_-</ -_) _` | '_/ _| ' \
"  \__|_||_\___\___/\_/|_|_|_|_|  |_| |_|_\___( )__/\___\__,_|_| \__|_||_|
"                                             |/
--]]

-- {{{ Tree Sitter Settings
require("nvim-treesitter.configs").setup {
  ensure_installed = { "java", "c", "lua", "python", "javascript", "html", "css", "vim", "markdown", "org", },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
}
-- }}}

-- {{{ NvimTree Settings
require("nvim-tree").setup {
  auto_reload_on_write = true,
  -- auto_close = true, --> Auto close has been deprecated
  open_on_setup = false, --> Auto open when no files opened
  open_on_setup_file = false, --> Auto open when files opened
  open_on_tab = false,
  sort_by = "name",
  view = {
    width = 30,
    --height = 30, --> No longer supported
    hide_root_folder = false,
    side = "right",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  }
}
--[[ Disabling NvimTree icons for no nerd fonts
vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 0,
  files = 0,
  folder_arrows = 0,
}
--]]
-- }}}

-- {{{ Telescope Settings
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  extensions = { file_browser = { hidden = true } },
}
require("telescope").load_extension "file_browser"
--require("telescope").load_extension("noice")
-- }}}

-- {{{ Which-Key Settings
local wk = require("which-key")
wk.setup()
wk.register({
  ["<leader>"] = {
    f = {
      name = "+file",
      f = { "<CMD>Telescope find_files<CR>", "Find File" },
      b = { "<CMD>Telescope file_browser<CR>", "Browse File" },
    },
  },
})
-- }}}
