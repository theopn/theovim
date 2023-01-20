# Theovim

![theovim-demo.gif](./static/theovim-demo.gif)

Theovim is my personal Neovim configuration. Due to the requests from my classmates in CS252: Systems Programming who wanted IDE features while working on the infamous "shell project," I decided to take the Neovim configuration out of my [dotfiles repository](https://github.com/theopn/dotfiles). I also like the name Theovim it's cute.

## Prerequisite

- `git` to update Theovim
- `bash` or a POSIX compliance shell
- A terminal emulator capable of rendering 256 xterm colors
- Latest version of Neovim (> 0.8).
  - For those poor souls working with 0.4.3 version Neovim on Purdue CS Data server, I included the appimage downloader that automatically adds alias to your `.bashrc`. Run `~/.theovim/nvim_appimage_downloader.sh` periodically to keep the appimage updated.
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs

## Installation

```bash
git clone https://github.com/theopn/theovim.git ~/.theovim
~/.theovim/install.sh
```

After deploying the configuration files, run Neovim once to `curl` [Packer](https://github.com/wbthomason/packer.nvim). Once the packer has been installed, run `:PackerSync` to install plugins.

