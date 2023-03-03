--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

--[[
-- @arg prompt: prompt to display
-- @arg options_table: Table of the form { [1. Display name] = lua_function_to_launch, ... }
--                    The number is used for the sorting purpose and will be removed in the display
--]]
local function create_selectable_menu(prompt, options_table)
  -- Given the tabl of options, populate an array with prmpt names
  local option_names = {}
  local n = 0
  for i, _ in pairs(options_table) do
    n = n + 1
    option_names[n] = i
  end
  table.sort(option_names)
  -- Return the prompt function. These global function var will be used when assigning keybindings
  local menu = function()
    vim.ui.select(option_names,
      {
        prompt = prompt,
        format_item = function(item) return item:gsub("%d. ", "") end
      },
      function(choice)
        local action_func = options_table[choice]
        if action_func ~= nil then
          action_func()
        end
      end)
  end
  return menu
end

-- {{{ LSP menu
local lsp_options = {
  ["1. Code Action"] = function() require("lspsaga.codeaction"):code_action() end,
  ["2. Definition and References"] = function() require("lspsaga.finder"):lsp_finder() end,
  ["3. Current Buffer Diagonostics"] = function() require("lspsaga.diagnostic"):show_buf_diagnsotic("buffer") end,
  ["4. Outline"] = function() require("lspsaga.outline"):outline() end,
  ["5. Hover Doc"] = function() vim.lsp.buf.hover() end, -- LSPSaga version requires Markdown treesitter
  ["6. Rename Variable"] = function() require("lspsaga.rename"):lsp_rename() end,
  ["7. Auto Format Toggle"] = function() vim.cmd("CodeFormatToggle") end,
}
THEOVIM_LSP_MENU = create_selectable_menu("Code action to perform at the current cursor", lsp_options)
-- }}}

-- {{{ Telescope menu
local telescope_options = {
  ["1. Git Commits"] = function() vim.cmd("Telescope git_commits") end,
  ["2. Git Status"] = function() vim.cmd("Telescope git_status") end
}
THEOVIM_TELESCOPE_MENU = create_selectable_menu("Telescope option to launch:", telescope_options)
-- }}}

-- {{{ Terminal menu
local terminal_options = {
  -- [[
  -- https://medium.com/@egzvor/vim-splits-cheat-sheet-2bf84fc99962
  --           | :top sp |
  -- |:top vs| |:abo| cu | |:bot vs |
  -- |       | |:bel| rr | |        |
  --           | :bot sp |
  -- botright == bot
  -- ]]
  ["1. Bottom"] = function()
    vim.api.nvim_command("botright " .. math.ceil(vim.fn.winheight(0) * 0.3) .. "sp | term")
    vim.api.nvim_input("i")
  end,
  ["2. Right"] = function()
    vim.api.nvim_command("bot " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term")
    vim.api.nvim_input("i")
  end,
  ["3. Floating"] = function() require("lspsaga.floaterm"):open_float_terminal() end,
  ["4. New Tab"] = function() vim.cmd("tabnew | term") end,
}
THEOVIM_TERMINAL_MENU = create_selectable_menu("Where would you like to launch a terminal?", terminal_options)
-- }}}

-- {{{ Miscellaneous features
local misc_options = {
  ["1. :Notepad"] = function() vim.cmd("Notepad") end,
  ["2. :TrimWhitespace"] = function() vim.cmd("TrimWhitespace") end,
  ["3. :TheovimUpdate"] = function() vim.cmd("TheovimUpdate") end,
  ["4. :TheovimHelp"] = function() vim.cmd("TheovimHelp") end,
  ["5. :TheovimVanillaVimHelp"] = function() vim.cmd("TheovimVanillaVimHelp") end,
  ["6. :TheovimInfo"] = function() vim.cmd("TheovimInfo") end,
}
THEOVIM_MISC_MENU = create_selectable_menu("What fun feature would you like to use?", misc_options)
--}}}
