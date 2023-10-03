--[[ ts.lua
-- $ figlet -f threepoint theovim
-- _|_|_  _  _   . _ _
--  | | |(/_(_)\/|| | |
--
-- Configuration for the Neovim's built-in treesitter highlight
--]]

require("nvim-treesitter.configs").setup {
  ensure_installed = { "bash", "c", "cpp", "latex", "lua", "markdown", "python", },
  auto_install = false,

  highlight = { enable = true, },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },
}
