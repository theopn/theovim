# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

Theovim is my modular Neovim configuration.

Some Theovim philosophies that might convince you to use Theovim:

1. If it can be made maintainable with Neovim API and Lua, do it
1. If a plugin must be used, keep the stock configuration as much as possible. The plugin author is more knowledgeable about the plugin than I am
1. Lua is a great language, even better if it's well-commented
1. You should be able to speak out the mnemonics in the keybinding
1. Three key strokes you can memorize is better than two strokes you cannot remember -- make a portal for often-used-features using `vim.ui.select` instead of million keybindings
1. There's no need to make a keybinding for every single features, make a "portal" for 

## Dependencies

- `git` to update Theovim
- `bash` or a POSIX compliance shell
- `npm` and `g++` (`gcc-c++`)for `bashls` and `clangd` language server
- A terminal emulator capable of rendering 256 xterm colors
- Neovim > 0.8.0
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs

## Installation

```bash
# Optional backup
[[ -e ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak
# Install Theovim files in ~/.config/nvim
git clone --depth 1 https://github.com/theopn/theovim.git ~/.config/nvim
```

## Usage

- `:TheovimHelp` contains all the custom commands and shortcuts
- `:TheovimUpdate` updates the latest changes to Theovim by pulling the changes and running update utilities
- `:TheovimInfo` shows the current version and information about the Neovim/Theovim

## Highlights

- Fully featured LSP with auto-completion, error detection, auto formatting, etc.
- Telescope fuzzy finder used for buffer selection, file opening, file browsing, etc.
- LaTeX and markdown compilation (`:VimtexCompile`, `:MarkdownPreviewToggle`)
- Templates for LaTeX, C header file, etc.
- Helpful features like `:Notepad`, `:TheovimVanillaVimHelp`, etc.
- Informative statusline
- Better tab/buffer management system using [tabby.nvim](https://github.com/nanozuki/tabby.nvim) and custom keybindings
- Use of standard (Neo)vim features (floating window, `vim.ui.select`, built-in dashboard, etc.) for the better performance

## Other Things

- Join (informal) Theovim user group [Discord server](https://discord.gg/er5EqNdkhH)

