# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

Theovim is an IDE layer for Neovim equipped with useful tools and plugins for computer science students. Theovim originated from my personal Neovim configuration, when I and my classmates in Purdue CS started taking CS252: Systems Programming, I got requests to separate my Neovim configuration from my Dotfiles repository. So after generalizing the configuration with helps from my friends, I present you Theovim.

## Prerequisite

- `git` to update Theovim
- `bash` or a POSIX compliance shell
- `npm` and `g++` (`gcc-c++`) compiler for `bashls` and `clangd` language server
- A terminal emulator capable of rendering 256 xterm colors
- Latest version of Neovim (> 0.8).
  - For those poor souls working with 0.4.3 version Neovim on the Purdue CS Data server, I included the appimage downloader that automatically adds an alias to your `.bashrc`. Run `~/.theovim/nvim_appimage_downloader.sh` periodically to keep the appimage updated.
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs

## Installation

Install the latest version of Neovim. Use `nvim_appimage_downloader` if your system does not permit a binary installation.

Execute the following commands:

```bash
git clone https://github.com/theopn/theovim.git ~/.theovim
~/.theovim/theovim-util.sh install
```

## Usage

- `:TheovimHelp` contains all the custom commands and shortcuts
- `:TheovimUpdate` updates the latest changes to Theovim by pulling the changes and running update utilities
- `:TheovimInfo` shows the current version and information about the Neovim/Theovim

## Highlights

- Instead of having complex bindings, Theovim groups some of the often but not frequently used LSP/plugin features and put them in selectable menus (try `<leader>ca` for LSP features and `<leader>fa` for fuzzy finder). Of course, there are keybindings for very frequently used features
- You can quickly toggle terminals whenever you want (bottom, left, floating, new tab, etc.) using `<leader>z`
- Theovim has a fuzzy finder (Telescope) for almost everything - file browser, file search, buffer search, Git commits, Git status, Git diff, etc.
- Theovim has built-in help documentation (`:TheovimHelp`)
- Theovim ships with fun tools (`:Scratchpad` `:Calculator`, `:Weather`, etc.)
- Configurations are well-commented; you are more than welcome to fork or reference the configuration and make it on your own
- There are less than 35 total plugins

### Text Editing

- has an auto-completion menu for text, date, file path, vim commands, and code snippets
- helps with LaTeX editing using Vimtex plugin (real-time PDF compile, auto-completion, etc.) and included homework template
- helps with markdown editing with real-time preview (`:MarkdownPreviewToggle`) and spell checker

### LSP

- You can use the `:Mason` and `:MasonInstall` commands to install LSP servers and Theovim will automatically set it up for you
- If the LSP supports it, codes will be automatically formatted on save. This can be turned off temporarily using the `:CodeFormatToggle` command
- For more features, try `<leader>ca` keybindings

## Other Things

- Join (informal) Theovim user group [Discord server](https://discord.gg/er5EqNdkhH)

