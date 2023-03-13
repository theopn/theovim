--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]
--

-- {{{ Colorcolumn based on ft
local ft_and_column_vals = {
  ["c"] = "80",
  ["cpp"] = "80",
  ["python"] = "80",
  ["java"] = "120",
  ["lua"] = "120",
}
local ft_names = {}
local n = 0
for i, _ in pairs(ft_and_column_vals) do
  n = n + 1
  ft_names[n] = i
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ColorColumn", { clear = true }),
  pattern = ft_names,
  callback = function() vim.wo.colorcolumn = ft_and_column_vals[vim.bo.filetype] end
})
-- }}}

-- {{{ Spell check in relevant buffer filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function() vim.wo.spell = true end
})
-- }}}

-- {{{ Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})
-- }}}

-- {{{ Terminal related autocmd
local terminal_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })

-- Insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen for when terminal is opened for the first time
  -- BufEnter when you navigate to an existing terminal buffer
  -- Some people use "BufWinEnter" and "WinEnter", but I seem to have no luck
  pattern = "term://*", --> TermOpen does not take a pattern value, but since it's a Lua table, it's ignored
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
