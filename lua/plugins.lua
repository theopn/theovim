--[[ plugins.lua
-- $ figlet -f rectangles theovim
--  _   _               _
-- | |_| |_ ___ ___ _ _|_|_____
-- |  _|   | -_| . | | | |     |
-- |_| |_|_|___|___|\_/|_|_|_|_|
--
-- This file:
-- - bootstraps Lazy.nvim
-- - installs plugins
-- - initialize plugins if setup() is provided
-- - provide a small configuration work in config field for some plugins
--   - Extensive config for some plugins (e.g., LSP, Telescope) will be done in separate modules
-- - installs external dependencies for some plugins
--]]

local plugins = {
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

  -- Oil.nvim file browser
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false, --> Do not hijack Netrw
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons", --> Icons
    }
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP server manager
      {
        "williamboman/mason.nvim",
        config = true,
      },
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

  -- Autopair
  {
    "windwp/nvim-autopairs",
    opts = {},
  },

  -- Keybinding guide
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
      require("which-key").register({
        ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
        ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
        ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
        ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
        ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
        ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      })
    end
  },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function() require("colorizer").setup() end, --> `opts` works iff module name == plugin name
  },

  -- Prettier notification
  {
    "rcarriga/nvim-notify",
    config = function() vim.notify = require("notify") end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",      --> colorscheme
    config = function()
      local is_transparent = true --> To disable transparency, set this to false
      require("tokyonight").setup({
        transparent = is_transparent,
        styles = {
          sidebars = is_transparent and "transparent" or "dark",
          floats = is_transparent and "transparent" or "dark",
        },
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = { "markdown" },
  },

  -- LaTeX integration
  {
    "lervag/vimtex",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "skim" --> macOS
      --vim.g.vimtex_view_method = "zathura" --> Linux
    end,
    ft = { "plaintex", "tex" },
  }
}

-- Lazy.nvim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, {})
