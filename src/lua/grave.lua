--[[
" figlet -f tombstone theovim-grave
"  ___ _,_ __,  _, _,_ _ _, _     _, __,  _, _,_ __,
"   |  |_| |_  / \ | / | |\/|    / _ |_) /_\ | / |_
"   |  | | |   \ / |/  | |  | ~~ \ / | \ | | |/  |
"   ~  ~ ~ ~~~  ~  ~   ~ ~  ~     ~  ~ ~ ~ ~ ~   ~~~
--]]

-- Add the following template to each entry:
--[[
what is it?:
why was it moved to the grave?:
why is it staying in the grave?:
--]]


--[[
what is it?: Auto closing mechanism for NvimTree
why was it moved to the grave?: https://github.com/nvim-tree/nvim-tree.lua/issues/1005
                                Auto close is not recommended due to Vim only supporting BufEnter vim event
                                In fact it's related to Theovim's first issue:
                                https://github.com/theopn/theovim/issues/1
why is it staying in the grave?: It worked for the most part and I was proud of it, until other people started posting
                                their own config
--]]
--[[
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
        and layout[3] == nil then
      vim.cmd("confirm quit")
    end
  end
})
--]]

--[[
what is it?: on_attach function to execute vim.lsp.buf.format() function before writing to a file
why was it moved to the grave?: I do not want auto format every time. I sometimes want to appreciate my messy code
why is it staying in the grave?: It is a very useful piece of code to attach it to an LSP server, do:
<lsp_server>.setup({ capabilities = capabilities, on_attach = on_attach, ... })
--]]
--[[
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end
    })
  end
end
--]]

--[[
What is it?: Custom Neovim statusline
Why was it moved to the grave?: It is not enough to display complex LSP information
Why is it staying in the grave?: Who knows I will want a minimal Neovim setup in the future
--]]
--[[
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html --
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}
-- Func that gets current mode --
local function get_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end
-- Editor info func --
local function get_filepath()
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if filepath == "" or filepath == "." then
    return " "
  end
  return string.format(" %%<%s/", filepath)
end
local function get_filename()
  local filename = vim.fn.expand "%:t"
  if filename == "" then
    return ""
  end
  return filename .. " "
end
local function get_filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end
local function get_lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end
-- Build statusline --
Statusline = {}
Statusline.active = function()
  return table.concat {
    "%#Statusline#",
    get_mode(),
    "%#Normal# ",
    get_filepath(),
    get_filename(),
    "%#Normal#",
    "%=%#StatusLineExtra#",
    get_filetype(),
    get_lineinfo(),
  }
end
function Statusline.inactive()
  return " %F"
end
-- Deploy statusline --
vim.api.nvim_exec([
augroup Statusline
au!
au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
augroup END],false)
--]]

--[[
What is it?: A custom function I tried to make for class note taking
Why was it moved to the grave?: Just look at it. Plus I do not have vim.pets plugin anymore
Why is it staying in the grave?: Well it's the first Lua function I wrote
--]]
--[[
-- {{{ Custom function for quickly opening a file
local notes_directory = "~/Documents/vim_notes/"
function new_note(class_name, note_name)
  date = os.date("%Y-%m-%d_")
  note_name = notes_directory .. class_name .. "/" .. date .. class_name .. "_" .. note_name .. ".md"
  print("Opening " .. note_name .. " ...")
  vim.cmd("e" .. note_name)
  vim.cmd("Pets cat Oliver")
end
-- }}}
--]]

