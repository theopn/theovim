--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]
--

-- {{{ Spell check in relevant buffer filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function() vim.wo.spell = true end
})
-- }}}

-- {{{ Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})
-- }}}

-- {{{ Terminal related autocmd
local terminal_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })

-- Insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- Some people got this to work with "BufWinEnter" and "WinEnter", but I seem to have no luck
  pattern = "term://*", --> TermOpen does not take pattern value, but since it's a Lua table, it's ignored
  callback = function() vim.cmd("startinsert") end
})

-- Automatically close the terminal when exit
-- TODO: Translate the following to Lua
-- autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
vim.api.nvim_create_autocmd("TermClose", {
  group = terminal_augroup,
  callback = function() vim.api.nvim_input("<CR>") end
})
-- }}}

-- {{{ Templates
local template_augroup = vim.api.nvim_create_augroup("Template", { clear = true })
local function add_template(pattern, file_path)
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = template_augroup,
    pattern = pattern,
    callback = function() vim.cmd("0r " .. file_path) end
  })
end

add_template("*.tex", "~/.theovim/templates/latex-hw-template.tex")
add_template("*.h", "~/.theovim/templates/c-header-template.h")
--}}}
