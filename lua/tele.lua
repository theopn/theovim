--[[ tele.lua
-- $ figlet -f fuzzy theovim
--  .-. .-.                      _
-- .' `.: :                     :_;
-- `. .': `-.  .--.  .--. .-..-..-.,-.,-.,-.
--  : : : .. :' '_.'' .; :: `; :: :: ,. ,. :
--  :_; :_;:_;`.__.'`.__.'`.__.':_;:_;:_;:_;
--
-- Configure telescope.nvim and related keybindings
--]]

local telescope = require("telescope")
local builtin = require("telescope.builtin")

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

-- Load extension after telescope is initialized
telescope.load_extension("file_browser")
pcall(require("telescope").load_extension, "fzf")

-- Git keymaps
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
-- One letter, frequently used keymaps
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- [F]ind mnemonics keymaps
vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "[F]ind [T]elescope: Telescope functions" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by rip[G]rep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>f/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = false,
  }))
end, { desc = "[F]ind [/] Open fuzzy finder for the current buffer words" })

vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { desc = "[F]ile [B]rowser" })
