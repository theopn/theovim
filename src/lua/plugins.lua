--[[
" figlet -f rectangles theovim-plugin
"  _   _               _               _         _
" | |_| |_ ___ ___ _ _|_|_____ ___ ___| |_ _ ___|_|___
" |  _|   | -_| . | | | |     |___| . | | | | . | |   |
" |_| |_|_|___|___|\_/|_|_|_|_|   |  _|_|___|_  |_|_|_|
"                                 |_|       |___|
--]]

-- {{{
local plugins = {
  -- {{{ Dependencies
  { "nvim-lua/plenary.nvim" }, --> Lua function library for Neovim
  { "kyazdani42/nvim-web-devicons" }, --> Icons for barbar, Telescope, and more
  -- }}}

  -- {{{ Appearance
  { "navarasu/onedark.nvim" }, --> Pretty theme
  { "EdenEast/nightfox.nvim" }, --> I am colorblind. This theme supports colorblind correction mode. Thank you.
  { "nvim-lualine/lualine.nvim" }, --> Status line plugin
  { "romgrk/barbar.nvim" }, --> Tab bar plugin
  { "glepnir/dashboard-nvim" }, --> Startup dashboard
  { "rcarriga/nvim-notify" }, --> Prettier notification
  { "doums/suit.nvim", --> Prettier vim.ui.select() and input()
    config = function() require("suit").setup() end
  },
  -- }}}

  -- {{{ File et Search
  { "lewis6991/gitsigns.nvim", --> Git information
    config = function() require("gitsigns").setup() end
  },
  { "lukas-reineke/indent-blankline.nvim", --> Indentation guide
    config = function() require("indent_blankline").setup() end
  },
  { "windwp/nvim-autopairs", --> Autopair
    config = function() require("nvim-autopairs").setup() end
  },
  { "p00f/nvim-ts-rainbow" }, --> Rainbow color matching for parentheses
  { "terrortylor/nvim-comment", --> Comments toggle
    config = function() require("nvim_comment").setup() end
  },
  { "nvim-treesitter/nvim-treesitter" }, --> Incremental highlighting
  { "kyazdani42/nvim-tree.lua" }, --> File tree
  { "nvim-telescope/telescope.nvim" }, --> Expendable fuzzy finder
  { "nvim-telescope/telescope-file-browser.nvim" }, --> File browser extension for Telescope
  { "folke/which-key.nvim" }, --> Pop-up dictionary for keybindings
  -- }}}

  -- {{{ LSP
  { "neovim/nvim-lspconfig" }, --> Neovim defult LSP engine
  { "williamboman/mason.nvim", --> LSP Manager
    config = function() require("mason").setup() end
  },
  { "williamboman/mason-lspconfig.nvim", }, --> Bridge between Mason and lspconfig
  { "rafamadriz/friendly-snippets" }, --> VS Code style snippet collection
  { "L3MON4D3/LuaSnip", --> Snippet engine that accepts VS Code style snippets
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end --> Load snippets from friendly snippets
  },
  { "saadparwaiz1/cmp_luasnip" }, --> nvim_cmp and LuaSnip bridge
  { "hrsh7th/cmp-nvim-lsp" }, --> nvim-cmp and lspconfig bridge
  { "hrsh7th/cmp-buffer" }, --> nvim-cmp source for buffer words
  { "hrsh7th/cmp-path" }, --> nvim-cmp source for file path
  { "hrsh7th/cmp-cmdline" }, --> nvim-cmp source for vim commands
  { "hrsh7th/nvim-cmp" }, --> Completion Engine
  { "folke/trouble.nvim" }, --> Pretty list of LSP error list
  { "glepnir/lspsaga.nvim", --> LSP hover menu, code action, rename, etc
    config = function() require('lspsaga').setup() end
  },

  -- {{{ Language specific
  { "iamcco/markdown-preview.nvim", --> MarkdownPreview to toggle
    run = function() vim.fn["mkdp#util#install"]() end, --> Binary installation for markdown-preview
    ft = { "markdown" },
  },
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
