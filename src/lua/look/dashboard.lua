--[[
" figlet -f stampatello theovim-look
" .  .                           .          .
" |- |-. ,-. ,-. .  , . ,-,-.    |  ,-. ,-. | ,
" |  | | |-' | | | /  | | | | -- |  | | | | |<
" `' ' ' `-' `-' `'   ' ' ' '    `' `-' `-' ' `
--]]
--

-- {{{ Variables
-- Mostly from: https://www.asciiart.eu/animals/cats
local olivers = {
  {
    [[     \/   \/          ]],
    [[     |\__/,|     _    ]],
    [[   _.|o o  |_   ) )   ]],
    [[  -(((---(((--------  ]]
  },
  -- This one is by Jonathan
  {
    [[      \/ \/                  ]],
    [[      /\_/\ _______          ]],
    [[     = o_o =  _ _  \     _   ]],
    [[     (__^__)   __(  \.__) )  ]],
    [[  (@)<_____>__(_____)____/   ]],
    [[    ♡ ~~ ♡ OLIVER ♡ ~~ ♡     ]],
  },
  {
    [[   \/   \/            ]],
    [[   |\__/,|        _   ]],
    [[   |_ _  |.-----.) )  ]],
    [[   ( T   ))        )  ]],
    [[  (((^_(((/___(((_/   ]]
  },
  {
    [[     \/       \/     ]],
    [[     /\_______/\     ]],
    [[    /   o   o   \    ]],
    [[   (  ==  ^  ==  )   ]],
    [[    )           (    ]],
    [[   (             )   ]],
    [[   ( (  )   (  ) )   ]],
    [[  (__(__)___(__)__)  ]],
  },
  {
    [[                         _    ]],
    [[        |\      _-``---,) )   ]],
    [[  ZZZzz /,`.-'`'    -.   /    ]],
    [[       |,4-  ) )-,_. ,\ (     ]],
    [[      '---''(_/--'  `-'\_)    ]]
  },
}
local header = olivers[math.random(#olivers)]

-- figlet -f small theovim
local logo = {
  [[ ___                    ]],
  [[  | |_  _  _     o __   ]],
  [[  | | |(/_(_)\_/ | |||  ]],
  "",
  os.date("[ ━━%m-%d━━ ❖ ━━%H:%M━━ ]"),
}

local buttons = {
  { "󰥨  Find File     ", "SPC f f", "Telescope find_files" },
  { "󰈙  Recent Files  ", "SPC f r", "Telescope oldfiles" },
  { "  File Browser  ",  "SPC f b", "Telescope file_browser" },
  { "  New File      ",  "       ", "enew" },
  { "  Config Theovim",  "       ", "e ~/.config/nvim/lua/user_config.lua" },
  { "  Exit Theovim  ",  "     ZZ", "quit" },
}
-- }}}

-- {{{ Highlights for the DB
local highlights = {
  ThVimLogoHl = { fg = "#FFB86C" },
  ThVimButtonsHl = { fg = "#8BE9FD" },
  ThVimMsgHl = { fg = "#BD93F9" },
}

for group, properties in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, properties)
end
-- }}}

-- {{{ Creating a dashboard
-- Add lines above and below arts
local emptyLine = string.rep(" ", vim.fn.strwidth(header[1]))
table.insert(header, 1, emptyLine)
header[#header + 1] = emptyLine
logo[#logo + 1] = emptyLine

local width = #header[1] + 3
local max_height = #header + 2 + #logo + 1 + (#buttons * 2) + 1 + 1 -- Numbers are paddings + one extra safety net

-- Function to create a new dashboard on a startup
-- Inspired from: https://github.com/chadcat7/kodo/blob/main/lua/ui/dash/init.lua
--                https://github.com/NvChad/ui/blob/dev/lua/nvchad_ui/nvdash/init.lua
local function open()
  -- Condition check and table init --

  -- Expands the current file name and see if it's empty
  if vim.fn.expand("%") ~= "" then return end

  -- Check if window is too small to launch
  if vim.api.nvim_win_get_height(0) < max_height then
    vim.notify("Window height is too small to launch the dashboard :(")
    return
  end

  -- The default empty buffer will go away when the new Dashboard buffer replaces it
  -- Instead of 0, vim.api.nvim_get_current_buf() could be used. However, because it's slow, the window flickers
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)

  -----------------------------------

  -- Init the table --

  -- Table for the contents
  local dashboard = {}
  -- add padding to the header
  local addPaddingToHeader = function(str)
    local pad = (vim.api.nvim_win_get_width(0) - vim.fn.strwidth(str)) / 2
    return string.rep(" ", math.floor(pad)) .. str .. " "
  end

  -- Function to format the button icon, description, and shortcuts
  local formatBtns = function(txt1, txt2)
    local btn_len = vim.fn.strwidth(txt1) + vim.fn.strwidth(txt2)
    local spacing = vim.fn.strwidth(header[1]) - btn_len
    return txt1 .. string.rep(" ", spacing - 1) .. txt2 .. " "
  end

  -- Inserting contentst to the DB table
  for _, val in ipairs(header) do
    table.insert(dashboard, val .. " ")
  end
  for _, val in ipairs(logo) do
    table.insert(dashboard, val .. " ")
  end
  for _, val in ipairs(buttons) do
    table.insert(dashboard, formatBtns(val[1], val[2]) .. " ") -- Button formatting
    table.insert(dashboard, emptyLine .. " ")                  -- New line
  end
  table.remove(dashboard, #dashboard)                          -- Remove the extra new line padding from the buttons

  --------------------

  -- Setting the dashboard --

  local result = {}
  for i = 1, vim.api.nvim_win_get_height(0) do
    result[i] = ""
  end

  local headerStartButActlyForHeader = math.floor((vim.api.nvim_win_get_height(0) / 2) - (#dashboard / 2) - 1)
  local headerStart = math.floor((vim.api.nvim_win_get_height(0) / 2) - (#dashboard / 2) - 1)

  -- adding the dashboard
  for _, val in ipairs(dashboard) do
    result[headerStartButActlyForHeader] = addPaddingToHeader(val)
    headerStartButActlyForHeader = headerStartButActlyForHeader + 1
  end

  -- setting the dasboard
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)

  -- setting the cursor
  vim.api.nvim_win_set_cursor(0, { headerStart + #header + #logo, math.floor(vim.o.columns / 2) - 15 })

  ---------------------------

  -- Setting highlihgts --

  local ThVimDashHl = vim.api.nvim_create_namespace("ThVimDashHl")
  local horiz_pad_index = math.floor((vim.api.nvim_win_get_width(0) / 2) - (width / 2)) - 2

  for i = headerStart, headerStart + #header - 2 do
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimLogoHl", i, horiz_pad_index, -1)
  end
  for i = headerStart + #header - 2, headerStart + #header + #logo - 2 do
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimMsgHl", i, horiz_pad_index, -1)
  end
  for i = headerStart + #header + #logo - 2, headerStart + #header + #logo - 2 + (#buttons * 2) do
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimButtonsHl", i, horiz_pad_index, -1)
  end

  -----------------------

  -- Keybindings --

  local currBtnLine = headerStart + #header + #logo + 2 --> Line number where the first button is located
  local btnsLineNums = {}

  -- Make a table of line numbers where buttons exist
  for _, _ in ipairs(buttons) do
    table.insert(btnsLineNums, currBtnLine - 2)
    currBtnLine = currBtnLine + 2
  end

  -- Setting hjkl and arrow keys movement
  local upMvmt = function()
    local curr = vim.fn.line(".") -- Current line
    -- Check if the current line number - 2 is button or move to the last element
    local target_line = vim.tbl_contains(btnsLineNums, curr - 2) and curr - 2 or btnsLineNums[#btnsLineNums]
    vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 15 })
  end
  local downMvmt = function()
    local curr = vim.fn.line(".") -- Current line
    -- Check if the current line number + 2 is button or move to the first element
    local target_line = vim.tbl_contains(btnsLineNums, curr + 2) and curr + 2 or btnsLineNums[1]
    vim.api.nvim_win_set_cursor(0, { target_line, math.floor(vim.o.columns / 2) - 15 })
  end
  vim.keymap.set("n", "h", "", { buffer = true })
  vim.keymap.set("n", "j", downMvmt, { buffer = true })
  vim.keymap.set("n", "k", upMvmt, { buffer = true })
  vim.keymap.set("n", "l", "", { buffer = true })
  vim.keymap.set("n", "<LEFT>", "", { buffer = true })
  vim.keymap.set("n", "<DOWN>", downMvmt, { buffer = true })
  vim.keymap.set("n", "<UP>", upMvmt, { buffer = true })
  vim.keymap.set("n", "<RIGHT>", "", { buffer = true })

  -- Setting return key movement
  vim.keymap.set("n", "<CR>", function()
    for i, v in ipairs(btnsLineNums) do
      if v == vim.fn.line(".") then
        local action = buttons[i][3] --> 3rd element of the buttons table
        if type(action) == "string" then
          vim.cmd(action)
        elseif type(action) == "function" then
          action()
        end
      end
    end
  end, { buffer = true })

  -----------------

  -- Buf options --

  vim.opt_local.filetype       = "TheovimDashboard"
  vim.opt_local.buflisted      = false
  vim.opt_local.modifiable     = false
  vim.opt_local.list           = false
  vim.opt_local.wrap           = false
  vim.opt_local.relativenumber = false
  vim.opt_local.number         = false
  vim.opt_local.cursorline     = false
  vim.opt_local.cursorcolumn   = false
  vim.opt_local.colorcolumn    = "0"

  -----------------
end
-- }}}

-- {{{ Open the dashboard
local function dashboardOpener()
  vim.defer_fn(open, 0) --> https://www.youtube.com/watch?v=GMS0JvS7W1Y
end
dashboardOpener()
-- }}}

-- {{{ Auto-resize the Dashboard
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if vim.bo.filetype == "TheovimDashboard" then
      vim.opt_local.modifiable = true
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
      dashboardOpener()
    end
  end,
})
-- }}}
