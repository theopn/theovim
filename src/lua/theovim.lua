vim.api.nvim_create_user_command("TheovimUpdate", function()
  vim.lsp.buf.format()
end, { nargs = 0 })
