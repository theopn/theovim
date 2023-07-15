--[[ dashboard.lua
-- $ figlet -f doom theovim
--  _   _                     _
-- | | | |                   (_)
-- | |_| |__   ___  _____   ___ _ __ ___
-- | __| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
-- | |_| | | |  __/ (_) \ V /| | | | | | |
--  \__|_| |_|\___|\___/ \_/ |_|_| |_| |_|
--
-- Provide a framework to open a dashboard on the Neovim startup when there is no buffer opened (only the empty buf)
--]]
Dashboard = {}

-- {{{ Variables
-- ASCII arts of
-- Mostly from: https://www.asciiart.eu/animals/cats
-- Make sure the length of each string is consistent, since the
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
  { "  Config Theovim",  "       ", "e ~/.config/nvim/lua/user_config.lua" },
  { "  Exit Theovim  ",  "     ZZ", "quit" },
}

-- Append empty lines to
local emptyLine = string.rep(" ", vim.fn.strwidth(header[1]))
table.insert(header, 1, emptyLine)
header[#header + 1] = emptyLine
logo[#logo + 1] = emptyLine

-- max height = empty line + #header + #logo + #buttons + empty lines after each button + empty line + 1 safety net
local max_height = 1 + #header + #logo + (#buttons * 2) + 1 + 1
-- }}}


--[[ create_highlights()
-- Create highlights for dashboard using vim.api.nvim_set_hl()
--]]
local create_highlights = function()
  local highlights = {
    ThVimLogoHl = { fg = "#FFB86C" },
    ThVimButtonsHl = { fg = "#8BE9FD" },
    ThVimMsgHl = { fg = "#BD93F9" },
  }
  for group, properties in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, properties)
  end
end
-- }}}

--[[ open()
-- When the buffer does not have a name, replace the buffer with the formated Dashboard contents
-- Inspired from: https://github.com/chadcat7/kodo/blob/main/lua/ui/dash/init.lua
--                https://github.com/NvChad/ui/blob/dev/lua/nvchad_ui/nvdash/init.lua
-- 0 will be used instead of nvim_get_current_buf() or nvim_get_current_win() unless win/buf handle needs to be saved
--]]
local render = function()
  -----------------------------------
  -- Condition check --

  -- Expands the current file name and see if it's empty
  if vim.api.nvim_buf_get_name(0) ~= "" then return end --> or use vim.fn.expand("%")

  -- Check if window is too small to launch
  if vim.api.nvim_win_get_height(0) < max_height then
    vim.notify("The window is too small to launch the dashboard :(")
    return
  end

  -- The default empty buffer will go away when the new Dashboard buffer replaces it
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

  -- Create a new buffer
  -- I could modify the current buffer, but if it's not a scratch buffer, it will be treated as writing to it
  -- This causes two problems: 1. indentation guide plugin will be active
  --                           2. when exiting, it will be treated as unsaved and will casue an error or prompt user
  local buf = vim.api.nvim_create_buf(false, true) --> listed false, scratchbuffer true
  vim.api.nvim_win_set_buf(0, buf)

  -----------------------------------
  -- Init the DB contents--

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

  -- setting the cursor. 15 is my best guess on where the first char of the button would be at
  vim.api.nvim_win_set_cursor(0, { headerStart + #header + #logo, math.floor(vim.o.columns / 2) - 15 })

  ---------------------------
  -- Setting highlihgts --

  local ThVimDashHl = vim.api.nvim_create_namespace("ThVimDashHl")
  --local horiz_pad_index = math.floor((vim.api.nvim_win_get_width(0) / 2) - (width / 2)) - 2

  for i = headerStart, headerStart + #header - 2 do --> Ignore last two empty lines
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimLogoHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimLogoHl", i, 0, -1)
  end
  for i = headerStart + #header - 2, headerStart + #header + #logo - 2 do --> Again, -2 because of empty lines
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimMsgHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimMsgHl", i, 0, -1)
  end
  for i = headerStart + #header + #logo - 2, headerStart + #header + #logo - 2 + (#buttons * 2) do --> Reach ends
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimButtonsHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimButtonsHl", i, 0, -1)
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

--[[ opener()
-- Wrap Dashboard.render() with schedule().
-- schedule_wrap({cb}) "Defers callback `cb` until the Nvim API is safe to call," and schedule() calls wrapped func
-- Let's say the user is resizing the terminal window. Without deferring, render() will jump ahead and start rendering,
-- which casues breakage in calculations and rendering. This allows render() to wait until Neovim says it's safe
--]]
Dashboard.opener = function()
  vim.schedule(render)
end

Dashboard.setup = function()
  create_highlights()
  Dashboard.opener()

  -- Make autocmd for
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.bo.filetype == "TheovimDashboard" then
        vim.opt_local.modifiable = true
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        Dashboard.opener()
      end
    end,
  })
end

return Dashboard
