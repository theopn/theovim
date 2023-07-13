--[[
" figlet -f small theovim-file,search
"  _   _                _           __ _ _                           _
" | |_| |_  ___ _____ _(_)_ __ ___ / _(_) |___   ___ ___ __ _ _ _ __| |_
" |  _| ' \/ -_) _ \ V / | '  \___|  _| | / -_)_(_-</ -_) _` | '_/ _| ' \
"  \__|_||_\___\___/\_/|_|_|_|_|  |_| |_|_\___( )__/\___\__,_|_| \__|_||_|
"                                             |/
--]]
--

local util = require("theovim_util")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  extensions = { file_browser = { hidden = true } },
})
require("telescope").load_extension("file_browser")

-- {{{ Custom Telescope menu
local telescope_options = {
  ["1. Search History"] = "Telescope search_history",
  ["2. Command History"] = "Telescope command_history",
  ["3. Commands"] = "Telescope commands",
  ["4. Help Tags"] = "Telescope help_tags",
  ["5. Colorscheme"] = "Telescope colorscheme"
}
local telescope_menu = util.create_select_menu("Telescope option to launch:", telescope_options)
vim.keymap.set('n', "<leader>fa", telescope_menu, { noremap = true, silent = true })
-- }}}
