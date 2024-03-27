local is_transparent = false    --> To disable transparency, set this to false

return {
  "folke/tokyonight.nvim",
  config = function()
    require("tokyonight").setup({
      transparent = is_transparent,
      styles = {
        sidebars = is_transparent and "transparent" or "dark",
        floats = is_transparent and "transparent" or "dark",
      },
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
