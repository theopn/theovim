--[[
" figlet -f tombstone theovim-grave
"  ___ _,_ __,  _, _,_ _ _, _     _, __,  _, _,_ __,
"   |  |_| |_  / \ | / | |\/|    / _ |_) /_\ | / |_
"   |  | | |   \ / |/  | |  | ~~ \ / | \ | | |/  |
"   ~  ~ ~ ~~~  ~  ~   ~ ~  ~     ~  ~ ~ ~ ~ ~   ~~~
--]]

local plugin_grave = {
  { "ellisonleao/glow.nvim", --> Markdown file preview. Requires glow installed
    ft = { "markdown" },
  },
}

-- Add the following template to each entry:
--[[
what is it?:
why was it moved to the grave?:
why is it staying in the grave?:
--]]

--[[
what is it?: Auto bracket closers by pure mapping
why was it moved to the grave?: Using a dedicated plugin
why is it staying in the grave?: I have been using it for forever and it worked well
--]]
--[[
-- Auto bracket closers --
{ 'i', "(", "()<LEFT>" },
{ 'i', "[", "[]<LEFT>" },
{ 'i', "{<CR>", "{<CR>}<ESC><S-o><ESC><S-i><TAB>" }, --> A little clunky to combat auto indentations
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
