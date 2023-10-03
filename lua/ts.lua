--[[ ts.lua
-- $ figlet -f threepoint theovim
-- _|_|_  _  _   . _ _
--  | | |(/_(_)\/|| | |
--
-- Configuration for the Neovim's built-in treesitter highlight
--]]

-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
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
end, 0)
