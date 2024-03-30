# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

## Overview

Theovim is my personal Neovim configuration, featuring a complete Telescope, Treesitter, and LSP setup, ~30 carefully selected plugins, and custom UI components in Lua.

Theovim:

0. prioritizes built-in Neovim features and Lua over plugins to avoid duplicate keybindings and features
0. keeps the stock configuration as much as possible when using external plugins -- the plugin author knows more about the plugin than I do
0. follows the [Open-closed Principle](https://en.wikipedia.org/wiki/Open-closed_principle) when organizing Lua configuration modules

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

- `:help theovim-tldr`: Summary of the Theovim help documentation

### Core

Theovim creates a solid base Neovim experience by maximizing built-in features.
The core module initializes sensible default options, autocmds, and keybindings without external plugins or modules.

- Automatically adjust indentation settings using [ftplugin](./after/ftplugin/)
- Spell check in relevant buffers
- Fold using Tree-sitter
- Smarter window navigation

For more information:

- `:help theovim-core-options`
- `:help theovim-core-keymaps`
- `:help theovim-core-commands`
- `:help theovim-core-autocmds`
- `:help theovim-core-netrw`

### Plugins

Theovim provides ~30 carefully selected plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).
Here are some of the plugins that will make your life easier.

- [oil.nvim](https://github.com/stevearc/oil.nvim) is a file manager that lets you manage files like a Vim buffer
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) automatically insert matching parentheses, quotes, etc.
- [which-key.nvim](https://github.com/folke/which-key.nvim) displays a popup with all possible keybindings
- [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) highlight color codes (hex codes, ANSI color name such as "Magenta", CSS functions, etc.)
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) highlights keywords such as `TODO`, `WARN`, etc.
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

- `:Telescope buffers` (`<leader><leader>`): lists all open buffers
- `:Telescope oldfile` (`<leader>s.`): finds recently opened files
- `:Telescope` (`<leader>ss`): searches Telescope functions using Telescope
- `:Telescope find_files` (`<leader>sf`): searches files in the current and children directories
- `:Telescope live_grep` (`<leader>sg`): searches for a word in the all the files in the current and children directories
- `:Telescope git_commits` (`<leader>gc`): searches for Git commits

For more information:

- `:help theovim-telescope`

### Treesitter

Treesitter (TS) is an incremental parser generator for more accurate syntax highlighting compared to the default regex-based highlighting.
TS also integrates with Vim's folding and selection mechanism to provide a more efficient navigation and editing experience.

For more information:

- `:help theovim-treesitter`

### LSP

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

### UI

Theovim features unique UI components written in Lua.

- Tabline: A simple and unique Tabline with buffer information to keep track of open buffers without sacrificing Vim's built-in tab system
- Statusline: A simple and informative Statusline inspired by Mini.nvim (https://github.com/echasnovski/mini.nvim), featuring Git and LSP information
- Dashboard: Startup dashboard with a random ASCII art that resemble my chunky cat Oliver

For more information:

- `:help theovim-ui`

### Tools

Unnecessary but fun features I made in Lua.

- `:Notepad`: Transparent floating window with a scratch buffer
- `:Floatterm`: Floating terminal with customizable size and location

The tools module is disabled by default.
Follow the comments in `lua/tools/init.lua` file to initialize features and tweak `.setup()` function and customize them.

### References

- Core:
    - [Neovim source code repository](https://github.com/neovim/neovim/tree/master/runtime/ftplugin) or `$VIMRUNTIME/ftplugin/`: Ftplugin examples
    - [A Reddit comment on "Share your favorite .vimrc lines..."](https://www.reddit.com/r/vim/comments/166a3ij/comment/jyivcnl/?utm_source=share&utm_medium=web2x&context=3): `SmarterWinMove` function
    - [How I'm able to take notes in mathematics lectures using LaTeX and Vim](https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly): keybinding to fix the nearest spelling mistake
- Telescope, Treesitter, and LSP:
    - [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim): Telescope, Treesitter, and LSP config
    - [nvim-cmp Wiki](https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations): Completion icon config
    - [nvim-lspconfig Wiki](https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders): Hover doc customization
- UI:
    - [NvChad UI plugin](https://github.com/NvChad/ui) and [Kodo](https://github.com/chadcat7/kodo/blob/4513340fb87146a3ed5fde55075b991b6eb550b5/lua/ui/dash/init.lua): Startup dashboard
    - [nvim-tabline](https://github.com/crispgm/nvim-tabline): `setup()` function for Tabline
    - [Mini.statusline](https://github.com/echasnovski/mini.statusline): Statusline
- Tools:
    - [Stuff.nvim](https://github.com/tamton-aquib/stuff.nvim): Notepad
- Documentation:
    - Built-in insert mode help documentation (`:h insert.txt`): Theovim help formatting
    - [Tokyo Night Wallpapers](https://github.com/tokyo-night/wallpapers/blob/main/night/minimal/stripes_00_2560x1440.png): Wallpaper in the screenshot


