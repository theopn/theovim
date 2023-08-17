# Changelog History

## Version 2023.07.29

Summary:

This version focuses on bug fixes and (more) refactoring after last two refactor update
**Update command was broken in the last update!** Sorry about this, and use:

`$ cd ~/.config/nvim && git pull && cd -`

to manually update Theovim. Afterwards, you can use `:TheovimUpdate`

Details:

- Add a new changelog style
- Add autocmd to close terminal window when exit code is 0
- Add `gx` binding to open URL in the current line (provided by netrw in "stock" Vim, but NvimTree disables netrw)
- Add LSP symbol and server information shortcut to [c]ode [a]tion keybinding
- Fix broken update and help doc commands

## V. 2023.07.19

This update is the second part of the refactoring project + improvement in built-in dashboard.
**Starting this update, users are to directly clone the repository to `~/.config` directory**.
You have two choices on using Theovim after this update:

1. **Migrate to the new file structure and continue getting the update (recommended)**:
    The command to migrate to the new structure is:
    $ cd ~/.theovim && git pull && cd -
    $ rm ~/.config/nvim && mv ~/.theovim ~/.config/nvim

    Or re-install Theovim using the following command:
    $ rm -rf ~/.config/nvim && git clone --depth 1 https://github.com/theopn/theovim.git ~/.config/nvim && rm -rf ~/.theovim

2. Continue using Theovim as-is by switching to `depr-file-struct` branch and do not receive future updates:
    Execute the following commands:
    $ cd ~/.theovim && git pull && cd -
    $ cd ~/.theovim && git fetch && git checkout depr-file-struct && cd -

Thank you for using Theovim! I hope this update to be the new starting point to further improve the experience.

## V. 2023.07.16.a

> This is a bug fix as the latest Telescope requires Neovim version 0.9.0 or above

- Removed LspSaga plug-in
- Downgrade Telescope version to 0.1.1

## V. 2023.07.16

This version is a part 1 of the major refactor project to make Theovim utilize more stock Neovim APIs and sustainable to maintain.
Many unused features are retiring and replaced.
Please refer to the list of commits for all the changes took place in this update.

- ADD descriptions for some keybindings (which is accessible through `[LDR]?`)
- ADD new changelog style with list of commits
- MODIFY statusline and Dashboard to be Lua module instead of direct execution
- MODIFY file structure and add extensive comments to the code
- REPLACE LSPSaga features in favor of stock Neovim `vim.lsp.buf` functions
- REPLACE OneDark/Pastelcula colorscheme with Tokyonight
- REPLACE tabby.nvim with bufferline.nvim
- REMOVE template features for C header and TeX
- REMOVE <CR> after termclose

## Version 2023.04.24

- Dashboard bug fix
- [TEMP] Manual support for semantic highlighting has been added - temporary until the colorscheme officially supports one

## Version 2023.04.08

- Current working directory in the StatusLine
- Dashboard revision (code base inspired by NvChad): Better error handling and faster startup
- Prettier help and changelog window

## Version 2023.03.18

- :TheovimUpdate is now executed in a floating, transparent terminal
- :Notepad is also semi-transparent
- Colorcolumn and tab configurations are adjusted based on file types
- Smaller Dashboard is launched if the window size is too small - removed in V. 2023.04.08

## Version 2023.03.14

- Statusline is totally redesigned!! One less plugin...
- :ZenModeIsh - Spawn a large NvimTree to center the text - removed in V. 2023.03.18

## Version 2023.03.07

- Improved new tab/kill buffer buffer selector (vim.ui.select())
- Terminal on the left option added
- :ShowChanges command
- Global StatusLine, StatusLine disabled in Dashboard
- Confirm option (ask for confirmation before closing unwritten buffer)
- Git menu ([LDR] g)

## Version 2023.02.27

- Neovim appimage installer removed as Purdue Linux server updated the Neovim package (Thanks Shriansh for submitting the request)
- Major file structure organization
- New built-in Dashboard in place of Dashboard.nvim
- BufferLine plugin (Barbar) replaced by UI wrapper for traditional Vim tab (Tabby)
- Tab-related keybindings:
  - [LDR] 1-9
  - [LDR] n prompts the user with a buffer to create a new tab with
  - [LDR] x prompts the user with a buffer to delete
- New keybinding for recently used files ([LDR] f r)

## Version 2023.02.23

**Installation method has changed. Please run `:TheovimUpdate` after restarting Neovim**

- Source code diet
- User configuration support
- You can now move to the next selected region in the auto-completed snippet using TAB

## Version 2023.02.18

- Terminal selection menu ([LDR] z)
- :TrimWhitespace command
- :Notepad command
- Misc feature selection menu ([LDR] m)

## Version 2023.02.12

- Default colorscheme changed from OneDark to Pastelcula
- C header file (*.h) template

## Version 2023.02.07

- LaTeX support through VimTex
- LaTeX templates

## Version 2023.02.03

- Weather command - removed in V. 2023.02.23
- Installation script major revision
- LSP/Telescope feature selection menu ([LDR] ca, [LDR] fa)

