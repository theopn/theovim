--[[
" figlet -f small theovim-file,search
"  _   _                _           __ _ _                           _
" | |_| |_  ___ _____ _(_)_ __ ___ / _(_) |___   ___ ___ __ _ _ _ __| |_
" |  _| ' \/ -_) _ \ V / | '  \___|  _| | / -_)_(_-</ -_) _` | '_/ _| ' \
"  \__|_||_\___\___/\_/|_|_|_|_|  |_| |_|_\___( )__/\___\__,_|_| \__|_||_|
"                                             |/
--]]
-- {{{ Tree Sitter Settings
require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "latex", "lua", "markdown", "python", "vim", },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
    }
}
-- }}}

-- {{{ NvimTree Settings
require("nvim-tree").setup {
    auto_reload_on_write = true,
    open_on_setup = false, --> Auto open when no files opened
    open_on_setup_file = false, --> Auto open when files opened
    open_on_tab = false,
    sort_by = "name",
    view = {
        width = 30,
        --height = 30, --> No longer supported
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    }
}
-- }}}

-- {{{ Telescope Settings
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            },
        },
    },
    extensions = { file_browser = { hidden = true } },
}
require("telescope").load_extension("file_browser")

--- Comprehensive list menu for Telescope functionalities
local telescope_options = {
    ["Git Commits"] = function() vim.cmd("Telescope git_commits") end,
    ["Git Status"] = function() vim.cmd("Telescope git_status") end
}
local telescope_option_names = {}
local n = 0
for i, _ in pairs(telescope_options) do
  n = n + 1
  telescope_option_names[n] = i
end
table.sort(telescope_option_names)
function THEOVIM_TELESCOPE_MENU()
  vim.ui.select(telescope_option_names, {
      prompt = "Telescope option to open",
  },
      function(choice)
        local action_func = telescope_options[choice]
        if action_func ~= nil then
          action_func()
        end
      end)
end

-- }}}

-- {{{ Vimtex Settings
vim.g.vimtex_view_method = "skim"

-- Add LaTeX template automatically
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("Template", { clear = true }),
    pattern = "*.tex",
    callback = function()
      vim.cmd("0r ~/.theovim/templates/latex-hw-template.tex")
    end
})
--}}}

-- {{{ Register selector command
-- https://www.reddit.com/r/neovim/comments/toke93/how_get_output_of_vim_command_as_lua_table/
local function get_register_table()
  local contents_str = vim.api.nvim_exec("register", true) -- vim.api.nvim_command_output() works too
  local contents_table = {}
  for line in contents_str:gmatch("[^\n]+") do
    table.insert(contents_table, line)
  end
  table.remove(contents_table, 1) -- remove the table header
  return contents_table
end

--[[
@arg inputstr in a format <char> "<char> <str>
     e.g. c "0 I yanked this string before
@return table index 1 = clipboard name ("<char>)
        table index 2 = clipboard content
--]]
local function format_register_table(inputstr)
  local contents = {}
  -- %a = all letters
  -- . = all characters
  -- () = captures the matched parts
  -- I got register name to work... I don't know how to get the rest of the string
  for line in inputstr:gmatch("%a. \"(.)   (.*)") do
    table.insert(contents, line)
  end
  vim.notify(contents[1])
  return contents
end

function THEOVIM_REGISTER_MENU()
  vim.ui.select(get_register_table(), {
      prompt = "Register content to paste at the current cursor:",
  },
      function(choice)
        if choice == nil then return end
        local content = format_register_table(choice)
        vim.cmd("put " .. content[1])
      end)
end

-- }}}
