# Theovim Information

> Current Version: 2023.04.08

# Changelog

## Version 2023.04.08

- Current working directory in the StatusLine
- Dashboard revision (code base inspired by NvChad): Better error handling and faster startup
- Prettier help and changelog window
- [temporary] LSP semantic highlighting takes over tree-sitter highlighting in Neovim 0.9.0. I disabled it manually for now, but I will come up with a more concrete solution soon

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

