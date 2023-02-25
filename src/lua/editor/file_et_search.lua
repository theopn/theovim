--[[
" figlet -f small theovim-file,search
"  _   _                _           __ _ _                           _
" | |_| |_  ___ _____ _(_)_ __ ___ / _(_) |___   ___ ___ __ _ _ _ __| |_
" |  _| ' \/ -_) _ \ V / | '  \___|  _| | / -_)_(_-</ -_) _` | '_/ _| ' \
"  \__|_||_\___\___/\_/|_|_|_|_|  |_| |_|_\___( )__/\___\__,_|_| \__|_||_|
"                                             |/
--]]
--
-- {{{ Automatically close the terminal when exit
-- TODO: Translate the following to Lua
-- autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
local terminal_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  group = terminal_augroup,
  callback = function()
    vim.api.nvim_input("<CR>")
  end
})
-- }}}

-- {{{ Templates
local template_augroup = vim.api.nvim_create_augroup("Template", { clear = true })
local function add_template(pattern, file_path)
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = template_augroup,
    pattern = pattern,
    callback = function()
      vim.cmd("0r " .. file_path)
    end
  })
end

add_template("*.tex", "~/.theovim/templates/latex-hw-template.tex")
add_template("*.h", "~/.theovim/templates/c-header-template.h")
--}}}
