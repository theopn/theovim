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
--
-- @requires ui.components for Statusline/Winbar components
--]]
local components = require("ui.components")

Statusline = {} --> global so that luaeval can keep calling build() function

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
    "%#PastelculaOrangeAccent# ",
    " ",
    vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), --> current working directory
    -- File info
    "  ",
    "%f", --> Current file/path relative to the current folder
    "%m", --> [-] for read only, [+] for modified buffer
    "%r", --> [RO] for read only, I know it's redundant
    "%<", --> Truncation starts here (and to the left) if file is too logn

    -- Git
    " %#PastelculaRedAccent#",
    components.git_status(),

    -- Spacer
    "%#Normal#",
    "%=",

    -- Global linter statsu
    components.linter_status(),

    -- File information
    "%#PastelculaPurpleAccent#",
    "   %Y ", --> Same as vim.bo.filetype:upper()

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
