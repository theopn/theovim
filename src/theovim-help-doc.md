# Theovim Help Documentation

<leader> = Space

## Help

- <leader> ?                  : Bring up key binding help pop-up
  - You can hit a key, pause for 2 seconds to bring up the key binding help pop-up
- :TheovimHelp                : Open this help document

## Insert Mode

- j k                         : ESC + :update (writes to a file if there is a change)
- <C-hjkl>                    : Navigate in insert mode

## Normal Mode

- z R                         : Open all folds

- <leader> z (Zsh)            : Open a ZSH terminal
- <leader> /                  : Clear search highlighting
- <leader> a (All)            : Select all text

- <leader> |                  : Open a vertically split window
- <leader> -                  : Open a horizontally split window
- <leader> hjkl               : Navigate around split windows
- <leader> arrow_keys         : Resize split windows

## Visual Mode

- <leader> y                  : Copy to '+' clipboard (should work for both MacOS and Linux with X11 window server)
- :'<,'>CommentToggle         : Comment the selected lines

## Buffer (tab) navigation

- <leader> t (Tab)            : Open a new buffer
- <leader> , ("<")            : Navigate to previous buffer (left in the top buffer list)
- <leader> . (">")            : Navigate to previous buffer (right in the top buffer list)
- <leader> k (Kill)           : Kill the current buffer

## Telescope

- <leader> n                  : Toggle file tree
- <leader> f a (Find Actions) : Selectable menu for commonly used Telescope features
- <leader> f f (Find File)    : Open up a fuzzy file searcher for the current and nested directories
- <leader> f b (File Browser) : Open up a fuzzy file finder (is able to navigate to previous directories)
- <leader> f / (Find /)       : Open up a fuzzy searcher for the current buffer

## LSP

- <C-e>                       : Close auto completion window

- :CodeFormatToggle           : Toggles code formatting on the write for supported file types
- <leader> c a (Code Actions) : Selectable menu for commonly used LSP features
- <leader> c d (Code Doc)     : Hover documentation
- <leader> c r (Code Rename)  : Renaming a variable
- :LSPInfo                    : Information on the current LSP server
- :LSPStop                    : Stop the LSP server
- :Mason                      : Tool to manage LSP servers

## Git

- :Git diffThis               : Git diff on a separate panel

## Spell Check

> Spell check is on by default in the markdown buffer

- <C-s>: In insert mode, fix the nearest spelling error and put the cursor back; in normal mode, toggle spelling suggestion on the cursor
- <leader> s t: set sspell!

## Markdown

- `:call mkpd#util#install()` to install binary necessary for the markdown preview
- `:MarkdownPreviewToggle`: Opens the compiled markdown file in the native browser

## Others

- `:Weather <optional-city>   : Prints out the pop-up weather report. Optional city argument (separate spaces by underscore e.g. Weather new_york) can be supplied

