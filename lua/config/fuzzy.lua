--[[ fuzzy.lua
-- $ figlet -f fuzzy theovim
--  .-. .-.                      _
-- .' `.: :                     :_;
-- `. .': `-.  .--.  .--. .-..-..-.,-.,-.,-.
--  : : : .. :' '_.'' .; :: `; :: :: ,. ,. :
--  :_; :_;:_;`.__.'`.__.'`.__.':_;:_;:_;:_;
--
-- Set up fuzzy finder plug-in. Currerntly Telescope.nvim
--]]
--

local util = require("util")
local telescope = require("telescope")

telescope.setup({
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
telescope.load_extension("file_browser")

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
