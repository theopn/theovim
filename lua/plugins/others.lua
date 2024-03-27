local M = {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim", --> Expandable fuzzy finer
    -- ! Latest version to support Neovim 0.8
    -- Will be updated in the future Theovim release
    --version = "0.1.1",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",                      --> Lua function library for Neovim
      {
        "nvim-telescope/telescope-fzf-native.nvim", --> Natively compiled C version of FZF for better sorting perf
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1 --> only build when `make` is available
        end,
      },
      "nvim-telescope/telescope-file-browser.nvim", --> File browser extension for Telescope
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP server manager
      "williamboman/mason.nvim",
      -- Bridge between lspconfig and mason
      "williamboman/mason-lspconfig.nvim",
      -- LSP status indicator
      { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
      -- Neovim dev environment
      "folke/neodev.nvim",
    }
  },

  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",             --> VS Code style snippet enginew
      "saadparwaiz1/cmp_luasnip",     --> Providing Luasnip as one of nvim-cmp source
      "hrsh7th/cmp-nvim-lsp",         --> nvim-cmp source for LSP engine
      "hrsh7th/cmp-buffer",           --> nvim-cmp source for buffer words
      "hrsh7th/cmp-path",             --> nvim-cmp source for file path
      "hrsh7th/cmp-cmdline",          --> nvim-cmp source for :commands
      "rafamadriz/friendly-snippets", --> Snippet collections
    },
  },

  -- Git information
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>gd", require("gitsigns").diffthis,
          { buffer = bufnr, desc = "[G]it [D]iff current buffer" })
      end
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
}

return M
