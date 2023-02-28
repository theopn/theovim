--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

-- {{{ Variables
local olivers = {
  {
    "     \\/   \\/          ",
    "     |\\__/,|     _    ",
    "   _.|o o  |_   ) )   ",
    "  -(((---(((--------  "
  },
  {
    "   \\/   \\/            ",
    "   |\\__/,|        _   ",
    "   |_ _  |.-----.) )  ",
    "   ( T   ))        )  ",
    "  (((^_(((/___(((_/   "
  },
  {
    "      \\/   \\/          ",
    "      |\\__/,|     _    ",
    "      |o o  |__ _) )   ",
    "    _.( T   )  `  /    ",
    "   ((_ `^--' /_<  \\    ",
    "   `` `-'(((/  (((/    "
  },
  {
    "     \\/       \\/     ",
    "     /\\_______/\\     ",
    "    /   o   o   \\    ",
    "   (  ==  ^  ==  )   ",
    "    )           (    ",
    "   (             )   ",
    "   ( (  )   (  ) )   ",
    "  (__(__)___(__)__)  "
  },
  {
    "                         _    ",
    "        |\\      _-``---,) )   ",
    "  ZZZzz /,`.-'`'    -.   /    ",
    "       |,4-  ) )-,_. ,\\ (     ",
    "      '---''(_/--'  `-'\\_)    "
  }
}
local header = olivers[math.random(#olivers)]

local buttons = {
  { "  Find File     ", "SPC f f", "Telescope find_files" },
  { "  Recent Files  ", "SPC f r", "Telescope oldfiles" },
  { "  File Browser  ", "SPC f b", "Telescope file_browser" },
  { "  New File      ", "       ", "enew" },
  { "  Exit Theovim  ", "ZZ     ", "quit" },
}

-- figlet -f small theovim
local message = {
  os.date("                 Today is %A, %d %B                 "),
  "   _   _                _         ",
  "  | |_| |_  ___ _____ _(_)_ __    ",
  "  |  _| ' \\/ -_) _ \\ V / | '  \\   ",
  "   \\__|_||_\\___\\___/\\_/|_|_|_|_|  ",
}

local footer = { os.date("Theovim %Y") }
-- }}}

-- {{{ Creating a dashboard
--[[
Function adopted from:
https://github.com/chadcat5207/nvide/blob/main/lua/ui/dash/init.lua
--]]
local emptyLine = string.rep(" ", vim.fn.strwidth(header[1]))

-- adding two lines above and below the art
table.insert(header, 1, emptyLine)
table.insert(header, 2, emptyLine)

header[#header + 1] = emptyLine
header[#header + 1] = emptyLine

-- adding two lines below the message
message[#message + 1] = emptyLine
message[#message + 1] = emptyLine

-- adding two lines above the footer
table.insert(footer, 1, emptyLine)

-- the width of the art
local width = #header[1] + 3

local open = function()
  if vim.fn.expand "%" == "" then
    -- setting the buf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)

    local dashboard = {}

    -- add padding to the header
    local addPaddingToHeader = function(str)
      local pad = (vim.api.nvim_win_get_width(0) - vim.fn.strwidth(str)) / 2
      return string.rep(" ", math.floor(pad)) .. str .. " "
    end

    -- add spacing to the buttons
    local addSpacingToBtns = function(txt1, txt2)
      local btn_len = vim.fn.strwidth(txt1) + vim.fn.strwidth(txt2)
      local spacing = vim.fn.strwidth(header[1]) - btn_len
      return txt1 .. string.rep(" ", spacing - 1) .. txt2 .. " "
    end

    -- inserting all the stuff that in there

    -- header
    for _, val in ipairs(header) do
      table.insert(dashboard, val .. " ")
    end

    -- message
    for _, val in ipairs(message) do
      table.insert(dashboard, val .. " ")
    end

    -- buttons
    for _, val in ipairs(buttons) do
      table.insert(dashboard, addSpacingToBtns(val[1], val[2]) .. " ")
      table.insert(dashboard, header[1] .. " ")
    end

    -- footer
    for _, val in ipairs(footer) do
      table.insert(dashboard, val .. " ")
    end

    local result = {}
    for i = 1, vim.api.nvim_win_get_height(0) do
      result[i] = ""
    end

    local headerStart = math.floor((vim.api.nvim_win_get_height(0) / 2) - (#dashboard / 2) - 1)
    local start = math.floor((vim.api.nvim_win_get_height(0) / 2) - (#dashboard / 2) - 1)

    -- adding the dashboard
    for _, val in ipairs(dashboard) do
      result[headerStart] = addPaddingToHeader(val)
      headerStart = headerStart + 1
    end

    -- setting the dasboard
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)

    -- setting the cursor
    vim.api.nvim_win_set_cursor(0, { start + #header + #message, math.floor(vim.o.columns / 2) - 18 })

    -- setting highlihgts
    local dashspace = vim.api.nvim_create_namespace "dasher"
    local horiz_pad_index = math.floor((vim.api.nvim_win_get_width(0) / 2) - (width / 2)) - 2

    for i = start, start + #header - 2 do
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashAscii", i, horiz_pad_index, -1)
    end

    for i = start + #header - 2, start + #header + #message - 2 do
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashMessage", i, horiz_pad_index, -1)
    end
    for i = start + #header + #message - 2, start + #header + #buttons * 2 + 1 do
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashButtons", i, horiz_pad_index, -1)
    end

    -- adding highlights for keys and icons
    for i = start + #header + #message - 1, start + #header + #buttons * 2 + 1, 2 do
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashButtonsSpl", i, horiz_pad_index + 40,
        horiz_pad_index + 42 + string.len(buttons[1][2]))
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashButtonsIco", i, horiz_pad_index + 3, horiz_pad_index + 7)
    end


    for i = start + #header + #message + #buttons * 2 + #footer - 2, start + #header + #buttons * 2 + 1 + #footer do
      vim.api.nvim_buf_add_highlight(buf, dashspace, "DashFooter", i, horiz_pad_index, -1)
    end

    -- adding the movement
    local firstbtnline = start + #header + #message + 2
    local keybinds = {}

    for _, _ in ipairs(buttons) do
      table.insert(keybinds, firstbtnline - 2)
      firstbtnline = firstbtnline + 2
    end

    vim.keymap.set("n", "h", "", { buffer = true })
    vim.keymap.set("n", "l", "", { buffer = true })

    vim.keymap.set("n", "k", function()
      local cur = vim.fn.line "."
      local target_line = vim.tbl_contains(keybinds, cur) and cur - 2 or keybinds[#keybinds]
      vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 18 })
    end, { buffer = true })

    vim.keymap.set("n", "j", function()
      local cur = vim.fn.line "."
      local target_line = vim.tbl_contains(keybinds, cur) and cur + 2 or keybinds[1]
      vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 18 })
    end, { buffer = true })


    vim.keymap.set("n", "<Left>", "", { buffer = true })
    vim.keymap.set("n", "<Right>", "", { buffer = true })

    vim.keymap.set("n", "<Up>", function()
      local cur = vim.fn.line "."
      local target_line = vim.tbl_contains(keybinds, cur) and cur - 2 or keybinds[#keybinds]
      vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 18 })
    end, { buffer = true })
    vim.keymap.set("n", "<Down>", function()
      local cur = vim.fn.line "."
      local target_line = vim.tbl_contains(keybinds, cur) and cur + 2 or keybinds[1]
      vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 18 })
    end, { buffer = true })

    -- on enter
    vim.keymap.set("n", "<CR>", function()
      for i, val in ipairs(keybinds) do
        if val == vim.fn.line "." then
          local action = buttons[i][3]

          if type(action) == "string" then
            vim.cmd(action)
          elseif type(action) == "function" then
            action()
          end
        end
      end
    end, { buffer = true })

    -- options
    -- DIFFER FROM THE ORIGINAL CODE
    vim.opt_local.filetype       = "TheovimDashboard"
    vim.opt_local.buflisted      = false
    vim.opt_local.modifiable     = false
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list           = false
    vim.opt_local.cursorline     = false
    vim.opt_local.cursorcolumn   = false
    vim.opt_local.colorcolumn    = "0"
    vim.opt_local.wrap           = false
    -- DIFFER FROM THE ORIGINAL CODE
  end
end

-- }}}

-- {{{ Adding highlights to the Dashboard
local highlights = {
  DashAscii = { fg = "#FFB86C" },
  DashButtons = { fg = "#8BE9FD" },
  DashButtonsSpl = { bg = "#8BE9FD", bold = true, },
  DashButtonsIco = { fg = "#8BE9FD", bold = true, },
  DashMessage = { fg = "#BD93F9" },
  DashFooter = { fg = "#44475A" },
}

for group, properties in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, properties)
end
-- }}}

-- {{{ Open the dashboard
local status, _ = pcall(open)
if (not status) then vim.notify("Window size is too small to display the dashboard :(") end
-- }}}


-- {{{ Auto-resize the Dashboard
--[[
Function adpoted from:
https://github.com/chadcat5207/nvide/blob/main/lua/themes/hl.lua
--]]
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if vim.bo.filetype == "TheovimDashboard" then
      vim.opt_local.modifiable = true
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
      open()
    end
  end,
})
-- }}}
