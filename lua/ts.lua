--[[ ts.lua
-- $ figlet -f threepoint theovim
-- _|_|_  _  _   . _ _
--  | | |(/_(_)\/|| | |
--
-- Configuration for the Neovim's built-in treesitter highlight
--]]

require("nvim-treesitter.configs").setup {
  ensure_installed = { "bash", "c", "lua", "markdown", "python", "vim" },
  auto_install = false,

  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = { enable = true },
}
