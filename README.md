# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

Theovim is a somewhat minimal, somewhat opinionated, totally stable, and totally functional IDE layer for Neovim. Theovim originated from my personal Neovim configuration, and when my classmates in CS252: Systems Programming wanted my configuration for the projects only available on the command-line SSH server, I developed Theovim. Theovim aims to be a configuration geared toward computer science students.

Some Theovim philosophies that might convince you to use Theovim:

1. Do not take away the "vanilla Vim" experience, improves it (e.g. Vim tab system over bufferline)
2. Lua is a great language, even better if it's well-commented
3. Simplicity is the best aesthetic
4. Keybindings you can memorize are the best keybindings. Theovim's keybindings use mnemonics, and instead of trying to make keybindings for every single feature, some of the often but not frequently used features are bundled in a selectable menu (e.g. `<SPC>ca/fa/m/z`)
5. If it can be done in less than 200 lines of code, do it (e.g. statusline, Dashboard, and other UI components). If a plugin must be used, keep it as close to the default/suggested configuration as possible. The plugin author is more knowledgeable about the code than I am

## Dependencies

- `git` to update Theovim
- `bash` or a POSIX compliance shell
- `npm` and `g++` (`gcc-c++`)for `bashls` and `clangd` language server
- A terminal emulator capable of rendering 256 xterm colors
- Latest version of Neovim (> 0.8)
  - ~~For those poor souls working with 0.4.3 version Neovim on the Purdue CS Data server, I included the appimage downloader that automatically adds an alias to your `.bashrc`. Run `~/.theovim/nvim_appimage_downloader.sh` periodically to keep the appimage updated.~~ Purdue CS finally updated Neovim image!
- [NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs

## Installation

```bash
git clone https://github.com/theopn/theovim.git ~/.theovim
~/.theovim/theovim-util.sh install
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

## Logo

Theovim startup dashboard randomly displays one of [five](https://github.com/theopn/theovim/blob/main/src/lua/look/dashboard.lua#L11) ASCII art for my cat [Oliver](https://theopark.me/writing/2022-08-10_my_linux_journey_so_far/). Most of the art is from [ASCII Art Archive](https://www.asciiart.eu/animals/cats), and because Oliver is chunky and has a short tail, I modified them accordingly. Try collecting screenshots of all five Oliver arts in the dashboard!

## Other Things

- Join (informal) Theovim user group [Discord server](https://discord.gg/er5EqNdkhH)

