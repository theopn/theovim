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
-- @arg options_table: Table of the form { [1. Display name] = lua_function_or_vim_cmd_to_launch, ... }
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
        local action = options_table[choice]
        if action ~= nil then
          if type(action) == "string" then
            vim.cmd(action)
          elseif type(action) == "function" then
            action()
          end
        end
      end)
  end
  return menu
end

-- {{{ LSP menu
local lsp_options = {
  ["1. Code Action"] = "Lspsaga code_action",
  ["2. Definition and References"] = "Lspsaga lsp_finder",
  ["3. Current Buffer Diagonostics"] = "Lspsaga show_buf_diagnostics",
  ["4. Outline"] = "Lspsaga outline",
  ["5. Hover Doc"] = function() vim.lsp.buf.hover() end, -- LSPSaga version requires Markdown treesitter
  ["6. Rename Variable"] = "Lspsaga rename",
  ["7. Auto Format Toggle"] = "CodeFormatToggle",
}
THEOVIM_LSP_MENU = create_selectable_menu("Code action to perform at the current cursor", lsp_options)
-- }}}

-- {{{ Telescope menu
local telescope_options = {
  ["1. Git Commits"] = "Telescope git_commits",
  ["2. Git Status"] = "Telescope git_status"
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
    vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * 0.3) .. "sp | term")
    vim.api.nvim_input("i")
  end,
  ["2. Left"] = function()
    vim.cmd("top " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term")
    vim.api.nvim_input("i")
  end,
  ["3. Right"] = function()
    vim.cmd("bot " .. math.ceil(vim.fn.winwidth(0) * 0.3) .. "vs | term")
    vim.api.nvim_input("i")
  end,
  ["4. Floating"] = "Lspsaga term_toggle",
  ["5. New Tab"] = function()
    vim.cmd("tabnew | term")
    vim.api.nvim_input("i")
  end,
}
THEOVIM_TERMINAL_MENU = create_selectable_menu("Where would you like to launch a terminal?", terminal_options)
-- }}}

-- {{{ Miscellaneous features
local misc_options = {
  ["1. :Notepad"] = "Notepad",
  ["2. :TrimWhitespace"] = function() vim.cmd("TrimWhitespace") end,
  ["3. :TheovimUpdate"] = function() vim.cmd("TheovimUpdate") end,
  ["4. :TheovimHelp"] = function() vim.cmd("TheovimHelp") end,
  ["5. :TheovimVanillaVimHelp"] = function() vim.cmd("TheovimVanillaVimHelp") end,
  ["6. :TheovimInfo"] = function() vim.cmd("TheovimInfo") end,
}
THEOVIM_MISC_MENU = create_selectable_menu("What fun feature would you like to use?", misc_options)
--}}}
