# Theovim

![theovim-demo.gif](./assets/theovim-demo.gif)

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

Install the latest version of Neovim. Use `nvim_appimage_downloader` if your system does not permit a binary installation.

```bash
git clone https://github.com/theopn/theovim.git ~/.theovim
~/.theovim/install.sh
```

After deploying the configuration files, run Neovim once to `curl` [Packer](https://github.com/wbthomason/packer.nvim). Once the packer has been installed, run `:TheovimUpdate` to install plugins.

## Usage

- `:TheovimHelp` contains all the custom commands and shortcuts - //TODO
- `:TheovimUpdate` updates the latest changes to Theovim by pulling the changes in `~/.theovim/` directory and run `:PackerSync`
- `:TheovimInfo` shows the current version and information about the Neovim/Theovim - //TODO
