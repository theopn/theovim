# V.2023.08.17

This is the final step of the major refactor plan.
It focuses on removing duplicate keybindings, revising documentation, and adding two new UI components: TabLine and Winbar.

Removed/changed keybindings and features:

- `[LDR] |`: Use `C-w v` instead
- `[LDR] -`: Use `C-w s` instead
- `[LDR] q`: Closes *tab* (i.e., it won't close the Vim if there's only one tab) instead of a window
            Use `C-w q` to close a window instead
- `[LDR] hjkl`: Use `C-w hjkl` instead
- `[LDR] <arrow-key>`: Use `C-w 10 <>-+` to resize window (10 can be any number of pixels) instead
                     Or use new `[LDR] <>-+` binding to resize window by 1/3 of the current size
- `[LDR] n`: Toggles `nvim-tree` instead of making a new tab. This is a swap with `[LDR] t`
- `[LDR] x`: Changed to `[LDR] k` ([k]ill buffer)
- `[LDR] t`: Creates a new tab instead of toggling `nvim-tree`. This is a swap with `[LDR] n`

- `:TheovimHelp` and was replaced by `:TheovimReadme`

New keybindings and features:

- `[LDR] <>-+`: Resize window by 1/3 of the current size
- `[LDR] k`: Replaces `[LDR] x` and [k]ills a buffer
- `[LDR] c e`: Open diagnostics pop-up for the current buffer ([c]ode [e]rror)
- `[LDR] c p`: Navigate to previous diagnostic ([c]ode [p]rev)
- `[LDR] c n`: Navigate to next diagnostic ([c]ode [n]ext)

- **`README.md` has been rewritten completely. Please read it!**
- `listchars` (how Vim renders tab, trailing and leading whitespaces, etc.) has changed. Refer to README.md for more information.
    - `indent-blankline` plug-in has been replaced with `leadmultispace`
- **New handmade tabline** replaces `bufferline.nvim`!
- **New handmade Winbar** is included to help you navigate split windows
    - LSP information has moved to Winbar to give a buffer-specific LSP information and de-clutter Statusline
- Highlighting and look of UI components has been changed slightly
- Completion source for Neovim APIs

