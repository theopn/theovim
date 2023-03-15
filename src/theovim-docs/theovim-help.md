# Theovim Help Documentation

<leader> = Space


## Management

- :TheovimUpdate             : Update Theovim
- :TheovimInfo               : View current version and changelog

## Help

- <leader> ?                 : Bring up finder for all the keymaps
- :TheovimHelp               : Open this help document
- :TheovimVanillaVimHelp     : Common Vim keybindings and workflows

## Insert Mode

- j k                        : ESC + :update (writes to a file if there is a change)
- <C-hjkl>                   : Navigate in insert mode
- Tab character              : Renders as "▷▷"
- Trailing space             : Renders as "␣"
- Non-breaking space         : Renders as "⍽"

## Normal Mode

- <leader> m                 : Menu for miscellaneous features that Theovim offers

- <leader> [z]sh             : Open a menu for launching a terminal
- <leader> /                 : Clear search highlighting
- <leader> [a]ll             : Select all text

- <leader> |                 : Open a vertically split window
- <leader> -                 : Open a horizontally split window
- <leader> q                 : Close the current split pane
- <leader> hjkl              : Navigate around split windows
- <leader> arrow_keys        : Resize split windows

## Visual Mode

- <leader> y                 : Copy to '+' clipboard (should work for both MacOS and Linux with X11 window server)
- <leader> p                 : Open a list of contents from available registers
- :'<,'>CommentToggle        : Comment the selected lines

## Buffer and Tab Navigation

> I recommend you to read the "Tab v.s. Buffer" section in `:TheovimVanillaVimHelp`

- <leader> [b]uffer          : Open a list of buffers
- <leader> , ("<")           : Navigate to the previous buffer
- <leader> . (">")           : Navigate to the next buffer
- <leader> x                 : Kill the current or selected buffer

- <leader> [n]               : Open a new tab with the current of the selected buffer
- <leader> 1-9               : Select a tab

## Telescope

- <leader> [t]ree            : Toggle file tree

- <leader> [f]ind [a]ctions  : Menu for commonly used Telescope features
- <leader> [f]ind [f]ile     : Open up a fuzzy file searcher for the current and nested directories
- <leader> [f]ind [r]ecent   : Open up a fuzzy file searcher for recently used files
- <leader> [f]ile [b]rowser  : Open up a fuzzy file finder (able to navigate to previous directories)
- <leader> [f]ind [/]        : Open up a fuzzy searcher for the current buffer

- <leader> j/k               : Cycle through selection

## LSP

- <C-e>                      : Close the auto-completion window

- :LinterToggle              : Toggle code formatter (see statusline for the on/off)

- <leader> [c]ode [a]ctions  : Menu for commonly used LSP features
- <leader> [c]ode [d]oc      : Hover documentation
- <leader> [c]ode [r]ename   : Renaming a variable
- :LSPInfo                   : Information on the current LSP server
- :LSPStop                   : Stop the LSP server
- :Mason                     : Tool to manage LSP servers

## Git

- <leader> [g]it             : Menu for Git related functionalities

## Spell Check

> Spell check is on by default in the markdown buffer

- <C-s>:                      : In insert mode, fix the nearest spelling error and put the cursor back
                                In normal mode, toggle spelling suggestion on the cursor
- <leader> s t                : Toggle spell checker

## Markdown and LaTeX

- :MarkdownPreviewToggle      : Opens the compiled markdown file in the native browser
- :VimtexCompile              : Start a real-time compilation in the PDF viewer

