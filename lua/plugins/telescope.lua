return {
  "nvim-telescope/telescope.nvim",   --> Expandable fuzzy finer
  -- ! Latest version to support Neovim 0.8
  -- Will be updated in the future Theovim release
  --version = "0.1.1",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",                        --> Lua function library for Neovim
    {
      "nvim-telescope/telescope-fzf-native.nvim",   --> Natively compiled C version of FZF for better sorting perf
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1   --> only build when `make` is available
      end,
    },
    "nvim-telescope/telescope-file-browser.nvim",   --> File browser extension for Telescope
  },
}
