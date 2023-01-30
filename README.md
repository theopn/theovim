# Theovim

![theovim-demo.gif](./assets/theovim-banner.jpg)

Theovim is my personal Neovim configuration. It strives to be a simple and maintainable full-Lua Neovim configuration with fill-IDE feature.
Due to the requests from my classmates in CS252: Systems Programming who wanted IDE features while working on the infamous "shell project," I decided to take the Neovim configuration out of my [dotfiles repository](https://github.com/theopn/dotfiles). I also like the name Theovim it's cute.

## Prerequisite

- `git` to update Theovim
- `bash` or a POSIX compliance shell
- A terminal emulator capable of rendering 256 xterm colors
- Latest version of Neovim (> 0.8).
  - For those poor souls working with 0.4.3 version Neovim on Purdue CS Data server, I included the appimage downloader that automatically adds alias to your `.bashrc`. Run `~/.theovim/nvim_appimage_downloader.sh` periodically to keep the appimage updated.
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs

## Installation

- Install the latest version of Neovim. Use `nvim_appimage_downloader` if your system does not permit a binary installation

Execute the following commands:

```bash
git clone https://github.com/theopn/theovim.git ~/.theovim
~/.theovim/theovim-util.sh install
```

- [Lazy.nvim](https://github.com/folke/lazy.nvim) package manager will automatically install all the missing plugins. If any error happens, run `:TheovimUpdate` to manually update the plugins
- `:Mason` is a language server manager. Use `:MasonInstall` to install language servers of your choice. Currently supported language servers are Bash (`bash-language-server), C, C++ (`clangd`), CSS (`css-lsp`), HTML (`html-lsp`), Python (`python-lsp-server`), and SQL (`sqlls`). In the future, any choice of your language server will work with Theovim.

## Usage

- `:TheovimHelp` contains all the custom commands and shortcuts
- `:TheovimUpdate` updates the latest changes to Theovim by pulling the changes in `~/.theovim/` directory and run `:PackerSync`
- `:TheovimInfo` shows the current version and information about the Neovim/Theovim - TODO
