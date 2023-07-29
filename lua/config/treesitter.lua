--[[ treesitter.lua
-- $ figlet -f threepoint theovim
-- _|_|_  _  _   . _ _
--  | | |(/_(_)\/|| | |
--
-- Configuration for the Neovim's built-in tree-sitter highlight
--]]
local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  ensure_installed = { "bash", "c", "lua", "markdown", "python", "vim" },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  }
})
