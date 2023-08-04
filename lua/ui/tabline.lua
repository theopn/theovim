--[[ tabline.lua
-- $ figlet -f tinker-joy theovim
--  o  o
--  |  |                  o
-- -o- O--o o-o o-o o   o   o-O-o
--  |  |  | |-' | |  \ /  | | | |
--  o  o  o o-o o-o   o   | o o o
--]]

local function create_highlight(group, fg, bg)
  local highlight_cmd = "highlight " .. group
  highlight_cmd = (fg ~= nil) and (highlight_cmd .. " guifg=" .. fg) or (highlight_cmd)
  highlight_cmd = (bg ~= nil) and (highlight_cmd .. " guibg=" .. bg) or (highlight_cmd)
  vim.cmd(highlight_cmd)
end

-- Create highlight groups
create_highlight("TabLineSel", "#5AB0F6", "#1e2030")

local function get_listed_bufs()
  local listed_buf = {}
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buflisted
    then
      table.insert(listed_buf, buf)
    end
  end
  return listed_buf
end

local M = {}

M.options = {
  show_index = true,
  show_modify = true,
  show_icon = true,
  fnamemodify = ':t',
  brackets = { "[", "]" },
  no_name = 'No Name',
  modify_indicator = ' [+]',
  inactive_tab_max_length = 0,
}

--[[ build()
-- Inspired by https://github.com/crispgm/nvim-tabline
--]]
M.build = function()
  -- Init
  local s = "%#TabLine# Theo   "
  local curr_tabnum = vim.fn.tabpagenr()
  for i = 1, vim.fn.tabpagenr("$") do
    -- Variables
    local winnum = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local curr_bufnum = buflist[winnum]
    local curr_bufname = vim.fn.bufname(curr_bufnum)
    local is_curr_buff_modified = vim.fn.getbufvar(curr_bufnum, "&modified")

    -- Highlight based on whether tab is selected or not
    s = s .. ((i == curr_tabnum) and "%#TabLineSel#" or "%#TabLine#")
    -- Initialize and make tab clickable (%nT)
    s = s .. " " .. "%" .. i .. "T"
    -- Index
    s = s .. i .. " "

    -- Icon
    if M.has_devicons then
      local ext = vim.fn.fnamemodify(curr_bufname, ":e")
      local icon = M.devicons.get_icon(curr_bufname, ext, { default = true }) .. " "
      s = s .. icon
    end
    -- Current name of the tab
    local display_curr_bufname = vim.fn.fnamemodify(curr_bufname, ":t")
    -- Limiting inactive tab name to n character + 3 (... that will be appended)
    local bufname_len_limit = 24
    if i ~= curr_tabnum and string.len(display_curr_bufname) > bufname_len_limit + 3 then
      display_curr_bufname = string.sub(display_curr_bufname, 1, 10) .. "..."
    end
    -- Append
    if display_curr_bufname ~= "" then
      s = s .. display_curr_bufname
    elseif vim.bo.filetype ~= "" then
      s = s .. vim.bo.filetype
    else
      s = s .. "Nameless"
    end

    -- Number of windows in the tab
    if #buflist > 1 then s = s .. " [+" .. (#buflist - 1) .. "]" end

    -- Make close button clickable ("%nX", %999X closes the current tab)
    s = s .. "%" .. i .. "X"
    -- Functional close button or modified indicator
    s = s .. ((is_curr_buff_modified == 1) and " " or " ")

    -- Reset button (%T)
    s = s .. "%T  "
  end

  -- Number of buffer and tab on the far right
  local buf_num_str = string.format("  Buf: %i ", #get_listed_bufs())
  local tab_num_str = string.format("  Tab: %i ", vim.fn.tabpagenr("$"))
  s = s .. "%#TabLineFill#" .. "%= %#TabLineSel#" .. buf_num_str .. "| " .. tab_num_str
  return s
end

function M.setup(user_options)
  if user_options then M.options = vim.tbl_extend('force', M.options, user_options) end
  M.has_devicons, M.devicons = pcall(require, 'nvim-web-devicons')

  function _G.nvim_tabline()
    return M.build()
  end

  vim.o.showtabline = 2
  vim.o.tabline = '%!v:lua.nvim_tabline()'
end

return M
