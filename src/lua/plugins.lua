--[[
" figlet -f rectangles theovim-plugin
"  _   _               _               _         _
" | |_| |_ ___ ___ _ _|_|_____ ___ ___| |_ _ ___|_|___
" |  _|   | -_| . | | | |     |___| . | | | | . | |   |
" |_| |_|_|___|___|\_/|_|_|_|_|   |  _|_|___|_  |_|_|_|
"                                 |_|       |___|
--]]
--
-- {{{
local plugins = {
  -- {{{ Dependencies
  { "nvim-lua/plenary.nvim" }, --> Lua function library for Neovim
  { "nvim-tree/nvim-web-devicons" }, --> Icons for barbar, Telescope, and more
  -- }}}

  -- {{{ Look and feel
  { "theopn/pastelcula.nvim" }, --> Colorscheme
  { "romgrk/barbar.nvim" }, --> Bufferline (tab) plugin
  { "nvim-lualine/lualine.nvim" }, --> Status line plugin
  { "glepnir/dashboard-nvim" }, --> Startup dashboard
  {
    "rcarriga/nvim-notify", --> Prettier notification
    config = function()
      require("notify").setup({ background_colour = "#282a36" }) --> The variable is needed if theme is transparent
      vim.notify = require("notify")
    end
  },
  {
    "doums/suit.nvim", --> Prettier vim.ui.select() and input()
    config = function() require("suit").setup() end
  },
  -- }}}

  -- {{{ File and search
  { "kyazdani42/nvim-tree.lua" }, --> File tree
  {
    "lewis6991/gitsigns.nvim", --> Git information
    config = function() require("gitsigns").setup() end
  },
  { "lukas-reineke/indent-blankline.nvim", --> Indentation guide
    config = function() require("indent_blankline").setup() end
  },
  { "windwp/nvim-autopairs", --> Autopair
    config = function() require("nvim-autopairs").setup() end
  },
  {
    "terrortylor/nvim-comment", --> Commenting region
    config = function() require("nvim_comment").setup() end
  },
  { "nvim-treesitter/nvim-treesitter" }, --> Incremental highlighting
  { "nvim-telescope/telescope.nvim" }, --> Expendable fuzzy finder
  { "nvim-telescope/telescope-file-browser.nvim" }, --> File browser extension for Telescope
  {
    "folke/which-key.nvim", --> Pop-up dictionary for keybindings
    config = function() require("which-key").setup() end
  },
  {
    "norcalli/nvim-colorizer.lua", --> Color highlighter
    config = function() require("colorizer").setup() end
  },
  -- }}}

  -- {{{ LSP
  { "neovim/nvim-lspconfig" }, --> Neovim defult LSP engine
  {
    "williamboman/mason.nvim", --> LSP Manager
    config = function() require("mason").setup() end
  },
  { "williamboman/mason-lspconfig.nvim", }, --> Bridge between Mason and lspconfig
  { "theopn/friendly-snippets" }, --> VS Code style snippet collection
  {
    "L3MON4D3/LuaSnip", --> Snippet engine that accepts VS Code style snippets
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end --> Load snippets from friendly snippets
  },
  { "saadparwaiz1/cmp_luasnip" }, --> nvim_cmp and LuaSnip bridge
  { "hrsh7th/cmp-nvim-lsp" }, --> Bridge betwee nvim-cmp and lspconfig
  { "hrsh7th/cmp-buffer" }, --> nvim-cmp source for buffer words
  { "hrsh7th/cmp-path" }, --> nvim-cmp source for file path
  { "hrsh7th/cmp-cmdline" }, --> nvim-cmp source for :commands
  { "hrsh7th/nvim-cmp" }, --> Completion Engine
  {
    "glepnir/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = true,
          separator = "  ",
          color_mode = false, -- I found color to be breaking when colorscheme change
        },
      })
    end
  }, --> LSP hover doc, code action, outline, statusbar LSP context, etc

  -- {{{ Language specific
  {
    "iamcco/markdown-preview.nvim", --> MarkdownPreview to toggle
    build = function() vim.fn["mkdp#util#install"]() end, --> Binary installation for markdown-preview
    ft = { "markdown" },
  },
  {
    "lervag/vimtex", --> LaTeX integration
    ft = { "plaintex", "tex" }
  }
  -- }}}
}
-- }}}

--- {{{ Lazy.nvim installation
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

require("lazy").setup(plugins)
--- }}}
