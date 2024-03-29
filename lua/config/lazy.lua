--- lazy.lua
---
--- $ figlet -f rectangles theovim
---  _   _               _
--- | |_| |_ ___ ___ _ _|_|_____
--- |  _|   | -_| . | | | |     |
--- |_| |_|_|___|___|\_/|_|_|_|_|
---
--- Bootstraps lazy.nvim plugin manager and loads modules in lua/plugins

-- Install Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Either pass the table (containing the plugin info) or string (a directory containing Lua modules)
-- Following will import all Lua files in lua/plugins
require("lazy").setup("plugins")
