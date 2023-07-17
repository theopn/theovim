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
    [[          \/   \/              ]],
    [[          |\__/,|     _        ]],
    [[        _.|o o  |_   ) )       ]],
    [[       -(((---(((--------      ]]
  },
  -- This one is by Jonathan
  {
    [[       \/ \/                   ]],
    [[       /\_/\ _______           ]],
    [[      = o_o =  _ _  \     _    ]],
    [[      (__^__)   __(  \.__) )   ]],
    [[   (@)<_____>__(_____)____/    ]],
    [[     ♡ ~~ ♡ OLIVER ♡ ~~ ♡      ]],
  },
  {
    [[        \/   \/                ]],
    [[        |\__/,|        _       ]],
    [[        |_ _  |.-----.) )      ]],
    [[        ( T   ))        )      ]],
    [[       (((^_(((/___(((_/       ]]
  },
  {
    [[          \/       \/          ]],
    [[          /\_______/\          ]],
    [[         /   o   o   \         ]],
    [[        (  ==  ^  ==  )        ]],
    [[         )           (         ]],
    [[        (             )        ]],
    [[        ( (  )   (  ) )        ]],
    [[       (__(__)___(__)__)       ]],
  },
  {
    [[                          _    ]],
    [[         |\      _-``---,) )   ]],
    [[   ZZZzz /,`.-'`'    -.   /    ]],
    [[        |,4-  ) )-,_. ,\ (     ]],
    [[       '---''(_/--'  `-'\_)    ]]
  },
}
local header = olivers[math.random(#olivers)]

-- $ figlet -f small theovim
local logo = {
  [[ ___                    ]],
  [[  | |_  _  _     o __   ]],
  [[  | | |(/_(_)\_/ | |||  ]],
  "",
  os.date("[ ━━%m-%d━━ ❖ ━━%H:%M━━ ]"),
}
-- Hard code button spacing here
local buttons = {
  { "󰥨  Find File      SPC f f", cmd = "Telescope find_files" },
  { "󰈙  Recent Files   SPC f r", cmd = "Telescope oldfiles" },
  { "  File Browser   SPC f b",  cmd = "Telescope file_browser" },
  { "  Config Theovim        ",  cmd = "e ~/.config/nvim/lua/config.lua" },
  { "  Exit Theovim        ZZ",  cmd = "quit" },
}

-- Calculating max width and make an empty length of the max width
local max_width = #header[1] + 1 --> A space appended in render() function
local empty_line = string.rep(" ", max_width)
-- Add empty line paddings for ASCII
table.insert(header, 1, empty_line)
header[#header + 1] = empty_line
logo[#logo + 1] = empty_line
-- max height = empty line + #header + #logo + #buttons + empty lines after each button + empty line + 1 safety net
local max_height = 1 + #header + #logo + (#buttons * 2) + 1 + 1
-- }}}


--[[ open()
-- When the buffer does not have a name, replace the buffer with the formated Dashboard contents
-- Inspired from: https://github.com/chadcat7/kodo/blob/main/lua/ui/dash/init.lua
--                https://github.com/NvChad/ui/blob/dev/lua/nvchad_ui/nvdash/init.lua
-- 0 will be used instead of nvim_get_current_buf() or nvim_get_current_win() unless win/buf handle needs to be saved
--]]
local render = function()
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  -----------------------------------
  -- Condition check --

  -- Expands the current file name and see if it's empty
  if vim.api.nvim_buf_get_name(0) ~= "" then return end --> or use vim.fn.expand("%")

  -- Check if window is too small to launch
  if win_height < max_height then
    vim.notify("Window is too small to launch the dashboard on :(")
    return
  end

  -- The default empty buffer will go away when the new Dashboard buffer replaces it
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

  -- Create a new buffer and replace the old one
  local buf = vim.api.nvim_create_buf(false, true) --> listed false, scratchbuffer true
  vim.api.nvim_win_set_buf(0, buf)

  -----------------------------------
  -- Init the DB contents--

  -- Table for the contents
  local dashboard = {}
  -- add padding to the header
  local add_padding = function(str)
    local pad = (win_width - vim.fn.strwidth(str)) / 2
    return string.rep(" ", math.floor(pad)) .. str .. " "
  end

  -- Inserting contentst to the DB table
  for _, val in ipairs(header) do
    table.insert(dashboard, add_padding(val) .. " ")
  end
  for _, val in ipairs(logo) do
    table.insert(dashboard, add_padding(val) .. " ")
  end
  for _, val in ipairs(buttons) do
    table.insert(dashboard, add_padding(val[1]) .. " ")
    table.insert(dashboard, empty_line .. " ")
  end
  table.remove(dashboard, #dashboard) --> Remove the extra new line padding from the buttons

  --------------------
  -- Setting the dashboard --

  local result = {}
  for i = 1, win_height do
    result[i] = ""
  end

  local hdr_start_idx_save = math.floor((win_height / 2) - (#dashboard / 2) - 1)
  local hdr_start_idx = math.floor((win_height / 2) - (#dashboard / 2) - 1)

  -- adding the dashboard
  for _, val in ipairs(dashboard) do
    result[hdr_start_idx_save] = val
    hdr_start_idx_save = hdr_start_idx_save + 1
  end

  -- setting the dasboard
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
  -- Buf options
  vim.opt_local.filetype       = "TheovimDashboard"
  vim.opt_local.buflisted      = false
  vim.opt_local.list           = false
  vim.opt_local.wrap           = true
  vim.opt_local.relativenumber = false
  vim.opt_local.number         = false
  vim.opt_local.cursorline     = false
  vim.opt_local.cursorcolumn   = false
  vim.opt_local.colorcolumn    = "0"
  vim.opt_local.modifiable     = true

  -- setting the cursor. 15 is my best guess on where the first char of the button would be at
  local cursor_column_idx      = (win_width > max_width) and (math.floor(win_width / 2) - 15) or (0)
  vim.api.nvim_win_set_cursor(0, { hdr_start_idx + #header + #logo, cursor_column_idx })

  ---------------------------
  -- Setting highlihgts --

  local dash_hl_namespace = vim.api.nvim_create_namespace("ThVimDashHl")
  --local horiz_pad_index = math.floor((vim.api.nvim_win_get_width(0) / 2) - (width / 2)) - 2

  for i = hdr_start_idx, hdr_start_idx + #header - 2 do --> Ignore last two empty lines
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimLogoHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, dash_hl_namespace, "ThVimLogoHl", i, 0, -1)
  end
  for i = hdr_start_idx + #header - 2, hdr_start_idx + #header + #logo - 2 do --> Again, -2 because of empty lines
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimMsgHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, dash_hl_namespace, "ThVimMsgHl", i, 0, -1)
  end
  for i = hdr_start_idx + #header + #logo - 2, hdr_start_idx + #header + #logo - 2 + (#buttons * 2) do --> Reach ends
    --vim.api.nvim_buf_add_highlight(buf, ThVimDashHl, "ThVimButtonsHl", i, horiz_pad_index, -1)
    vim.api.nvim_buf_add_highlight(buf, dash_hl_namespace, "ThVimButtonsHl", i, 0, -1)
  end

  -----------------------
  -- Keybindings --

  local curr_btn_line = hdr_start_idx + #header + #logo + 2 --> Line number where the first button is located
  local btns_line_nums = {}

  -- Make a table of line numbers where buttons exist
  for _, _ in ipairs(buttons) do
    table.insert(btns_line_nums, curr_btn_line - 2)
    curr_btn_line = curr_btn_line + 2
  end

  -- Setting hjkl and arrow keys movement
  local upMvmt = function()
    local curr = vim.fn.line(".") -- Current line
    -- Check if the current line number - 2 is button or move to the last element
    local target_line = vim.tbl_contains(btns_line_nums, curr - 2) and curr - 2 or btns_line_nums[#btns_line_nums]
    vim.api.nvim_win_set_cursor(0, { target_line, cursor_column_idx })
  end
  local downMvmt = function()
    local curr = vim.fn.line(".") -- Current line
    -- Check if the current line number + 2 is button or move to the first element
    local target_line = vim.tbl_contains(btns_line_nums, curr + 2) and curr + 2 or btns_line_nums[1]
    vim.api.nvim_win_set_cursor(0, { target_line, cursor_column_idx })
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
    for i, v in ipairs(btns_line_nums) do
      if v == vim.fn.line(".") then
        local action = buttons[i].cmd
        if type(action) == "string" then
          vim.cmd(action)
        elseif type(action) == "function" then
          action()
        end
      end
    end
  end, { buffer = true })

  -----------------
  vim.opt_local.modifiable = false
  -----------------
end

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
