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

-- Load file browser extension AFTER telescope is initialized
telescope.load_extension("file_browser")

-- Git keymaps
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
-- One letter, frequently used keymaps
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- [S]earch mnemonics keymaps
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch for [S]earch: Telescope functions" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sr", builtin.registers, { desc = "[S]earch [R]egisters" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>s/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = false,
  }))
end, { desc = "[S]earch [/] Open fuzzy finder for the current buffer words" })

vim.keymap.set("n", "<leader>sb", telescope.extensions.file_browser.file_browser, { desc = "[S]earch [B]rowser" })
