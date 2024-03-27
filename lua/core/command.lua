--- command.lua
---
--- $ figlet -f small theovim
---  _   _                _
--- | |_| |_  ___ _____ _(_)_ __
--- |  _| ' \/ -_) _ \ V / | '  \
---  \__|_||_\___\___/\_/|_|_|_|_|
---
--- User commands of Theovim
---


--- Trims trailing whitespace
--- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning when no match found, c: confirm
local function trim_whitespace()
  local win_save = vim.fn.winsaveview()
  vim.cmd("keeppatterns %s/\\s\\+$//ec")
  vim.fn.winrestview(win_save)
end
vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, { nargs = 0 })

-- Changing current working directory
vim.api.nvim_create_user_command("CD", ":lcd %:h", { nargs = 0 })
