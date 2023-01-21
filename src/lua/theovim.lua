--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]

vim.api.nvim_create_user_command("TheovimUpdate", function()
  vim.api.nvim_command(":! cd ~/.theovim && git pull")
  require('packer').sync()
end, { nargs = 0 })

vim.api.nvim_create_user_command("TheovimHelp", function()
  print("Coming soon! Look for GitHub update and use :TheovimUpdate often!")
end, { nargs = 0 })

vim.api.nvim_create_user_command("TheovimInfo", function()
  print("Coming soon! Look for GitHub update and use :TheovimUpdate often!")
end, { nargs = 0 })
