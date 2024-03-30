return
{
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- TODO: add [t, ]t keymaps
  opts = {
    signs = false
  },
}
