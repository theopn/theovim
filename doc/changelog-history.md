# Changelog History

## V. 2023.07.19

> This update is the second part of the refactoring project + improvement in built-in dashboard.
> **Starting this update, users are to directly clone the repository to `~/.config` directory**.
> You have two choices on using Theovim after this update:
>
> 1. **Migrate to the new file structure and continue getting the update (recommended)**:
>
> The command to migrate to the new structure is:
> $ cd ~/.theovim && git pull && cd -
> $ rm ~/.config/nvim && mv ~/.theovim ~/.config/nvim
>
> Or re-install Theovim using the following command:
> $ rm -rf ~/.config/nvim && git clone --depth 1 https://github.com/theopn/theovim.git ~/.config/nvim && rm -rf ~/.theovim
>
> 2. Continue using Theovim as-is by switching to `depr-file-struct` branch and do not receive future updates:
> Execute the following commands:
> $ cd ~/.theovim && git pull && cd -
> $ cd ~/.theovim && git fetch && git checkout depr-file-struct && cd -
>
> Thank you for using Theovim! I hope this update to be the new starting point to further improve the experience.

- [dev f1ea2b9] feat(core): add more keybinding helpers
- [dev 2914dbf] refactor(init): modify init.lua to fit the new file struct
- [dev 5cbb24a] refactor(config): move tree-sitter config to config folder
- [dev a210126] refactor(lsp): migrate lsp config to a separate folder
- [dev b789bf8] refactor(completion): move completion config to config folder
- [dev 2ac8677] fix(ui): use notify_once instead of notify for dashboard error msg to prevent spamming
- [dev 67200d0] refactor(fuzzy finder): move fuzzy finder config to config folder
- [dev ea5b5bb] style(lsp): add file name in the header comment
- [dev 7c88b65] refactor(lsp): move lsp config file to config folder
- [dev f6aeb14] feat(plugins): add nvimtree compatibility for bufferline
- [dev aeffe2d] style(ui): remove commented code from dashboard
- [dev 40567f3] docs(license) rename license and modify name
- [dev eb1b732] fix(ui): remove unnecessary empty space appending
- [dev 68e2e5a] refactor(ui): rename dashboard variables and move code to make more sense
- [dev 9ce56c3] refactor(ui): modify dashboard code so the header is the longest string and buttons and bindings are combined
- [dev 653e3b9] docs: add the new installation procedure to the readme
- [dev 98879da] style(util): add comments to notepad
- [dev be677a5] fix(init): fix the name of the config file
- [dev 7500dde] refactor(config): remove old user_config
- [dev 2532e44] fix: fix gitignore config file name
- [dev 5f02894] fix(config): fix config template directory
- [dev 6a682de] refactor!: change file structure so that repo can be cloned directly to ~/.config

## V. 2023.07.16.a

> This is a bug fix as the latest Telescope requires Neovim version 0.9.0 or above

- [dev 82f7107] refactor(core): remove LSPSaga plugin and commented out codes in core.lua
- [dev 22f2788] fix(plugins)!: downgrade Telescope version to 0.1.1 for Purdue Data server users

## V. 2023.07.16

> This version is a part 1 of the major refactor project to make Theovim utilize more stock Neovim APIs and sustainable to maintain.
> Many unused features are retiring and replaced.
> Please refer to the list of commits for all the changes took place in this update.

- ADD descriptions for some keybindings (which is accessible through `[LDR]?`)
- ADD new changelog style with list of commits
- MODIFY statusline and Dashboard to be Lua module instead of direct execution
- MODIFY file structure and add extensive comments to the code
- REPLACE LSPSaga features in favor of stock Neovim `vim.lsp.buf` functions
- REPLACE OneDark/Pastelcula colorscheme with Tokyonight
- REPLACE tabby.nvim with bufferline.nvim
- REMOVE template features for C header and TeX
- REMOVE <CR> after termclose

Commits:

- [dev eb4e62b] docs: update theovim banner image
- [dev eb34f74] feat(core): add more keybinding descriptions
- [dev 66fea7b] fix(ui): fix dashboard issue where width of the window was not checked (#17)
- [dev b87ce6d] feat(ui): change dashboard as a module
- [dev 9ea8b5b] refactor(ui): change statusline to be a lua module
- [dev 47231a7] style(util): change file name from theovim_util to util
- [dev 3e453dc] feat(colorscheme)!: replace Onedark/Pastelcula with Tokyonight
- [dev dfcd08d] feat(tabline)!: replace tabby.nvim with bufferline.nvim
- [dev 1c94391] refactor(dashboard): use Lua multiline string instead of double quotes for ASCIIs
- [dev 7413c00] fix(dashboard): fix the bug where empty buffer is present after DB is loaded
- [dev ac563dd] feat(core): revise buffer navigation binding ([]) and reinstate window resize bindings
- [dev 010a3a6] refactor(core): combine three core files to one, rename core/plugin module to plugin
- [dev 5016000] fix(keybindings): replace deprecated LSPSaga rename function with stock Neovim's
- [dev 5d4bfc1] refactor(util): separate menu and notepad function to theovim_util.lua module
- [dev 1c80be6] style(statusline): add Lua doc comments for each function
- [dev dae66be] style(custom_menus): fix git menu numbering
- [dev 918d3d7] refactor(statusline): remove some highlightings for modes
- [dev 44726d4] fix(dashboard): fix bug where the last button wasn't highlighted
- [dev 7c2e101] refactor(core): remove <CR> after termclose and organize code base
- [dev 81df9ee] refactor!: drop template features for C header and latex
- [dev 60c89bb] docs(help): add <leader>hjkl help back
- [dev 9fb56df] feat(keybinds): add <leader>hjkl for window navigation back
- [dev 5222fdf] docs(info/changelog): add an example for new changelog style and separate old changelog contents
- [dev 4867c37] refactor(keybindings): remove :update in jk and remove <leader>hjkl bindings for window navigation
- [dev 071de95] fix: replace obsolete pre-3.0 Nerd Font icons for UI elements
- [dev 4e6c2e3] fix: replace obsolete pre-3.0 Nerd Font icons for completion menu

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

