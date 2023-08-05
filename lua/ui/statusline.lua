--[[ statusline.lua
-- $ figlet -f stacey theovim
-- ________________________________ _________________
-- 7      77  7  77     77     77  V  77  77        7
-- !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  |
--   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  |
--   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  |
--   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!
--
-- Provide functions to build a Lua table and Luaeval string used for setting up Vim statusline
-- @requires ui.components for Statusline/Winbar components
--]]
local components = require("ui.components")

Statusline = {} --> global so that luaeval can keep calling build() function

--[[ create_highlight()
-- Creates a new highlight group. Suitable for groups with foreground or background only
-- @arg group: Name of the highlight group to create
-- @arg fg: Foreground hex code. If none is provided, nil is used
-- @arg bg: Background hex code. If none is provided, nil is used
--]]
local function create_highlight(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

-- Create highlight groups
create_highlight("StatusLineBlueAccent", "#5AB0F6", nil)
create_highlight("StatusLineRedAccent", "#FAA5A5", nil)
create_highlight("StatusLineGreenAccent", "#BDF7AD", nil)
create_highlight("StatusLineYellowAccent", "#F3FFC2", nil)
create_highlight("StatusLinePurpleAccent", "#D3B3F5", nil)
create_highlight("StatusLineOrangeAccent", "#FFCAA1")
create_highlight("StatusLineLightGreyAccent", "#B7C2C7")
create_highlight("StatusLineGreyAccent", "#828B8F", nil)


--[[ build()
-- Build a table with statusline components
-- @return Lua table of Vim statusline components
--]]
Statusline.build = function()
  return table.concat({
    -- Mode
    components.update_mode_colors(), --> Dynamically set the highlight depending on the current mode
    components.format_mode(),

    -- folder, file name, and status
    "%#StatusLineOrangeAccent# ",
    " ",
    vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), --> current working directory
    "  ",
    "%f",                                      --> Current file/path relative to the current folder
    "%m",                                      --> [-] for read only, [+] for modified buffer
    "%r",                                      --> [RO] for read only, I know it's redundant

    -- Git
    " %#StatusLineRedAccent#",
    "%<", --> Truncation starts here if file is too logn
    components.git_status(),

    -- Spacer
    "%#Normal#",
    "%=",

    -- File information
    "%#StatusLinePurpleAccent#",
    "   %Y", --> Same as vim.bo.filetype:upper()

    components.ff_and_enc(),
    -- Location in the file
    "  󰓾 %l:%c %P " --> Line, column, and page percentage
  })
end

--[[ setup()
-- Set vim.o.statusline to luaeval of the build function
--]]
Statusline.setup = function()
  vim.opt.statusline = "%{%v:lua.Statusline.build()%}"
end

return Statusline
