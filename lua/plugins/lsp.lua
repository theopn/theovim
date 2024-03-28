return {
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
}
