# Theovim Information

> Current Version: 2023.03.07

# Changelog

## Version 2023.03.07

- Improved new tab/kill buffer buffer selector (utilizes vim.ui.select())
- Terminal on the left option added
- :ShowChanges command
- Global statusline, statusline disabled in Dashboard
- Confirm option on

## Version 2023.02.27

- Neovim appimage installer removed as Purdue Linux server updated the Neovim package (Thanks Shriansh for submitting the request)
- Major file structure organization
- New Dashboard
- Bufferline plugin (Barbar) replaced by UI wrapper for traditional Vim tab (Tabby)
- Tab-related keybindings:
  - <leader>1-9
  - <leader>n prompts the user with a buffer to create a new tab with
  - <leader>x prompts the user with a buffer to delete
- New keybinding for recently used files (<leader> f r)

## Version 2023.02.23

**Installation method has changed. Please run `:TheovimUpdate` after restarting Neovim**

- Source code diet
- User configuration support
- You can now move to the next selected region in the auto-completed snippet using <TAB>

## Version 2023.02.18

- Terminal selection menu (<leader>z)
- :TrimWhitespace command
- :Notepad command
- Misc feature selection menu (<leader>m)

## Version 2023.02.12

- Default colorscheme changed from OneDark to Pastelcula
- C header file (#.h) template

## Version 2023.02.07

- LaTeX support through Vimtex
- LaTeX templates

## Version 2023.02.03

- Weather command - removed in 2023.02.23
- Installation script major revision
- LSP/Telescope feature selection menu (<leader>ca, <leader>fa)

