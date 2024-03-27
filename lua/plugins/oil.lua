local M = { "stevearc/oil.nvim" }

M.opts = {
  default_file_explorer = false, --> do not hijack netrw
}

M.dependencies = {
  { "nvim-tree/nvim-web-devicons" },
}

return M
