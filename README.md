# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

## Overview

Theovim is my personal Neovim configuration, featuring built-in Neovim options and LSP setup, ~30 carefully selected plugins, and custom UI components written in Lua.

Theovim:

0. prioritizes built-in Neovim features and Lua over plugins to avoid duplicate keybindings and features
0. keeps the stock configuration as much as possible when using external plugins -- the plugin author knows more about the plugin than I do
0. follows [Open-closed Principle](https://en.wikipedia.org/wiki/Open-closed_principle) for organizing Lua configuration modules

**For more information, read the [Highlights](#highlights) section and the built-in [help documentation](./doc/theovim.txt) using `:help theovim`.**

## Prerequisites

- A terminal emulator with true color support. A few recommendations:
    - [Wezterm](https://wezfurlong.org/wezterm/) (my personal choice)
    - [Kitty](https://sw.kovidgoyal.net/kitty/)
    - [Alacritty](https://alacritty.org/)
    - [iTerm 2 for MacOS](https://iterm2.com/)
    - Alternatively, you can use a GUI Neovim client like [Neovide](https://neovide.dev/)
- Neovim version > 0.8.3
    - Unfortunately, my school's Debian server uses outdated Neovim, forcing me to use some deprecated APIs and older versions of plug-ins
    - These will be indicated in code comments and will be fixed as soon as possible
    - Thanks to my friend Shriansh for at least making them upgrade from 0.5 to 0.8
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs
- `make` and some C compiler to compile `telescope-fzf-native.nvim`
- `npm`, `g++` (`gcc-c++`), and `unzip` for some LSP servers
- `git` to update Theovim

## Installation

> [!NOTE]
> I highly recommend you to fork this repository and tweak settings on your own.

```bash
# Optional backup
[[ -e ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak
# Install Theovim files in ~/.config/nvim
git clone --depth 1 https://github.com/theopn/theovim.git ~/.config/nvim
```

## Highlights

### TODO Core

For more information:

- `:help theovim-core-options`
- `:help theovim-core-keymaps`
- `:help theovim-core-autocmds`

### Plugins

Theovim provides ~30 carefully selected plugins managed by [Lazy.nvim]. Here are some of the plugins that will make sure life easier.

- [oil.nvim](https://github.com/stevearc/oil.nvim) is a file manager that lets you manage files like a Vim buffer
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) automatically insert matching parentheses, quotes, etc.
- [which-key.nvim](https://github.com/folke/which-key.nvim) displays a popup with all possible keybindings
- [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) highlight color codes (hex codes, ANSI color name such as "Magenta", CSS functions, etc.)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) provides Git signs in the gutter (+, -, ~, etc.) as well as other useful Git functionalities, such as diff, navigating hunks, and blame tool
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) is a beautiful default theme for Theovim
- [Markdown Preview](https://github.com/iamcco/markdown-preview.nvim) offers a real-time previewer for markdown files in your browser
- [VimTeX](https://github.com/lervag/vimtex) is a LaTeX integration for Vim, providing syntax highlights and real-time compilation.

For more information:

- `:help theovim-plugins`

### Telescope

[Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is a fuzzy finder for Neovim.
It allows you to jump between files, buffers, and anything you could think of in a matter of a few keystrokes.

My Telescope configuration is heavily inspired by [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
a configuration template written by TJ DeVries who is the author of Telescope.nvim and the core maintainer of Neovim.

A few of my favorite Telescope features:

- `:Telescope oldfile` (`<leader>?`): finds recently opened files
- `:Telescope buffers` (`<leader><space>`): lists all open buffers
- `:Telescope` (`<leader>ft`): searches Telescope functions using Telescope
- `:Telescope find_files` (`<leader>ff`): searches files in the current and children directories
- `:Telescope live_grep` (`<leader>fg`): searches for a word in the all the files in the current and children directories
- `:Telescope git_commits` (`<leader>gc`): searches for Git commits

For more information:

- `:help theovim-telescope`

### Treesitter

//TODO w v.s. w/o treesitter

Treesitter (TS) is an incremental parser generator for more accurate syntax highlighting compared to the default regex-based highlighting.
TS also integrates with Vim's folding and selection mechanism to provide a more efficient navigation and editing experience.

For more information:

- `:help theovim-treesitter`

### LSP

// TODO: LSP functionalities screenshot

Neovim's built-in LSP offers modern IDE features for any language you want (assuming one of the 350+ Neovim LSP servers supports the language you use) with flexible customizability and low resource usage.
Like Telescope, my LSP configuration is heavily inspired by TJ's Kickstart.nvim.

There are three main parts of LSP:

- Diagnostics: error diagnostics and fix suggestions
- LSP: hover documentation, formatting, refactoring, and much more
- Completion: auto-completion for keywords, variables, templates (snippets), buffer words, and paths

For more information:

- `:help theovim-diagnostic`
- `:help theovim-lsp`
- `:help theovim-completion`

### TODO UI

Theovim features unique UI components written in Lua.

- Tabline: A simple and unique Tabline with buffer information to keep track of open buffers without sacrificing Vim's built-in tab system
- Statusline: A simple and informative Statusline inspired by Mini.nvim (https://github.com/echasnovski/mini.nvim), featuring Git and LSP information
- Dashboard: Startup dashboard with a random ASCII art that resemble my chunky cat Oliver

For more information:

- `:help theovim-ui`

### Tools

> [!TODO]
> Tools is a WIP module. It will contain some of a fun Lua project I did, such as Notepad and a floating terminal utility.

### References

- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim): Telescope, Treesitter, and LSP config
- [nvim-cmp Wiki](https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations): Completion icon config
- [nvim-lspconfig Wiki](https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders): Hover doc customization
- [NvChad UI plugin](https://github.com/NvChad/ui): Startup dashboard
- [nvim-tabline](https://github.com/crispgm/nvim-tabline): `setup()` function for Tabline
- [Mini.statusline](https://github.com/echasnovski/mini.statusline): Statusline
- [Stuff.nvim](https://github.com/tamton-aquib/stuff.nvim): Notepad
- Built-in insert mode help documentation (`:h insert.txt`): Theovim help formatting

