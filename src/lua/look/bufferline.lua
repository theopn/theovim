--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

-- require("bufferline").setup({
--   animation = true,
--   closable = false,
--   maximum_padding = 1,
--   maximum_length = 30,
--   -- New buffer inserted at the end (instead of after curr buffer). Compitability w/ built-in bprev bnext command
--   insert_at_end = true, --> Or I can use Barbar's BufferPrevious/BufferNext commands in keybinding...
-- })
-- -- Compitability w/ nvim-tree --
-- local nvim_tree_events = require("nvim-tree.events")
-- local bufferline_api = require("bufferline.api")
-- local function get_tree_size() return require("nvim-tree.view").View.width end
-- nvim_tree_events.subscribe("TreeOpen", function() bufferline_api.set_offset(get_tree_size()) end)
-- nvim_tree_events.subscribe("Resize", function() bufferline_api.set_offset(get_tree_size()) end)
-- nvim_tree_events.subscribe("TreeClose", function() bufferline_api.set_offset(0) end)

vim.o.showtabline = 2

require('tabby.tabline').use_preset('active_wins_at_tail')
