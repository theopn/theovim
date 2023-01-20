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
what is it?: another janky on_attach function that asks for user confirmation on formatting
why was it moved to the grave?: None of the autocmd event fits the scenario. any writing related is a pain since
                                you frequently writes to a file, BufLeave asks every time you switch a tab, etc
why is it staying in the grave?: First prompt I made
--]]
--[[
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.ui.select({ "Format", "No Format" },
          { prompt = "Would you like to format the code before you leave?" },
          function(choice)
            if choice == "Format" then
              vim.lsp.buf.format()
              vim.cmd("write")
            end
          end)
      end
    })
  end
end
-]]

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
