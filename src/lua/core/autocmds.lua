--[[
" figlet -f standard theovim-init
"  _   _                     _                 _       _ _
" | |_| |__   ___  _____   _(_)_ __ ___       (_)_ __ (_) |_
" | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ _____| | '_ \| | __|
" | |_| | | |  __/ (_) \ V /| | | | | | |_____| | | | | | |_
"  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|     |_|_| |_|_|\__|
--]]
--

-- Note: Use vim.opt_local over vim.bo whenever possible, since opt_local directly corresponds to setlocal cmd and is higher level api

-- {{{ File settings based on ft
-- Dictionary for supported file type (key) and the table containing values (values)
local ft_style_vals = {
  ["c"] = { colorcolumn = "80", tabwidth = 2 },
  ["cpp"] = { colorcolumn = "80", tabwidth = 2 },
  ["python"] = { colorcolumn = "80", tabwidth = 4 },
  ["java"] = { colorcolumn = "120", tabwidth = 4 },
  ["lua"] = { colorcolumn = "120", tabwidth = 2 },
}
-- Make an array of the supported file type
local ft_names = {}
local n = 0
for i, _ in pairs(ft_style_vals) do
  n = n + 1
  ft_names[n] = i
end
-- Using the array and dictionary, make autocmd for the supported ft
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FileSettings", { clear = true }),
  pattern = ft_names,
  callback = function()
    vim.opt_local.colorcolumn = ft_style_vals[vim.bo.filetype].colorcolumn
    vim.opt_local.shiftwidth = ft_style_vals[vim.bo.filetype].tabwidth
    vim.opt_local.tabstop = ft_style_vals[vim.bo.filetype].tabwidth
    vim.opt_local.softtabstop = ft_style_vals[vim.bo.filetype].tabwidth
  end
})
-- }}}

-- {{{ Spell check in relevant buffer filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "tex", "text" },
  callback = function() vim.opt_local.spell = true end
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

-- Switch to insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = terminal_augroup,
  pattern = "term://*", --> only for "BufEnter", ignored Lua table key when evaluating TermOpen
  callback = function() vim.cmd("startinsert") end
})
-- }}}
