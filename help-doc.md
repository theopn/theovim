# Theovim Help Documentation

<C-a> means pressing 'a' while holding 'Ctrl'.
f a means pressing 'f' and then pressing 'a' in a short time.

## Insert Mode

- j k: ESC + :update (writes to a file if there is a change)
- <C-hjkl>: Navigate in insert mode

## Normal Mode

- z R: Open all folds

- <leader> z: Open a ZSH terminal
- <leader> /: Clear search highlighting
- <leader> a: Select all text

- <leader> |: Open a vertically split window
- <leader> -: Open a horizontally split window
- <leader> hjkl: Navigate around split windows
- <leader> arrow_keys: Resize split windows

## Visual Mode

- <leader> y: Copy to '+' clipboard (should work for both MacOS and Linux with X11 window server)

## Spell Check

- <C-s>: In insert mode, fix the nearest spelling error and put the cursor back; in normal mode, toggle spelling suggestion on the cursor
- <leader> + s + t: set sspell!

## Help

- <leader> ? Bring up key binding help pop-up
- :TheovimHelp: Open this help document

## Buffer (tab) navigation

- <leader> t: Open a new buffer
- <leader> ,: Navigate to previous buffer (left in the top buffer list)
- <leader> .: Navigate to previous buffer (right in the top buffer list); remember using '<' and '>'
- <leader> k: Kill the current buffer

## Telescope

- <leader> n: Toggle file tree
- <leader> f f: Open up a fuzzy file searcher for the current and nested directories
- <leader> f b: Open up a fuzzy file finder (is able to navigate to previous directories)
- <leader> f /: Open up a fuzzy searcher for the current buffer

## LSP

- <C-e>: Close auto completion window

- :Format: Formats the code
- <leader> c f: Code reference
- <leader> c a: Code action
- <leader> c d: Hover documentation
- <leader> c r: Renaming a variable
- :LSPInfo
- :Mason

## Git

- :Git diffThis: Git diff on a separate panel

