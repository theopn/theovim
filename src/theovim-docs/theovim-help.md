# Theovim Help Documentation

- [LDR] = Space
- C-x   = Control + x

## Management

- :TheovimUpdate          : Update Theovim

- :TheovimInfo            : View current version and changelog

## Help

- [LDR] ?                 : Bring up finder for all the keymaps
- :TheovimHelp            : Open this help document
- :TheovimVanillaVimHelp  : Common Vim keybindings and workflows

## Insert Mode

- j k                     : ESC
- C-h/j/k/l               : Navigate in insert mode
- Tab character           : Renders as "▷▷"
- Trailing space          : Renders as "␣"
- Non-breaking space      : Renders as "⍽"

## Normal Mode

- [LDR] m                 : Menu for miscellaneous features that Theovim offers

- [LDR] [z]sh             : Open a menu for launching a terminal
- [LDR] /                 : Clear search highlighting
- [LDR] [a]ll             : Select all text

- [LDR] |                 : Open a vertically split window
- [LDR] -                 : Open a horizontally split window
- [LDR] q                 : Close the current split pane
- [LDR] arrow_keys        : Resize split windows

## Visual Mode

- [LDR] y                 : Copy to '+' clipboard (should work for both MacOS and Linux with X11 window server)
- [LDR] p                 : Open a list of contents from available registers
- :'<,'>CommentToggle     : Comment the selected lines

## Buffer and Tab Navigation

> I recommend you to read the "Tab v.s. Buffer" section in `:TheovimVanillaVimHelp`

- [LDR] [b]uffer          : Open a list of buffers
- [LDR] , ("<")           : Navigate to the previous buffer
- [LDR] . (">")           : Navigate to the next buffer
- [LDR] x                 : Kill the current or selected buffer

- [LDR] [n]ew             : Open a new tab with the current of the selected buffer
- [LDR] 1-9               : Select a tab

## Telescope

- [LDR] [t]ree            : Toggle file tree

- [LDR] [f]ind [a]ctions  : Menu for commonly used Telescope features
- [LDR] [f]ind [f]ile     : Open up a fuzzy file searcher for the current and nested directories
- [LDR] [f]ind [r]ecent   : Open up a fuzzy file searcher for recently used files
- [LDR] [f]ile [b]rowser  : Open up a fuzzy file finder (able to navigate to previous directories)
- [LDR] [f]ind [/]        : Open up a fuzzy searcher for the current buffer

- [LDR] j/k               : Cycle through selection

## LSP

- C-e                     : Close the auto-completion window

- :LinterToggle           : Toggle code formatter (see statusline for the on/off)

- [LDR] [c]ode [a]ctions  : Menu for commonly used LSP features
- [LDR] [c]ode [d]oc      : Hover documentation
- [LDR] [c]ode [r]ename   : Renaming a variable
- :LSPInfo                : Information on the current LSP server
- :LSPStop                : Stop the LSP server
- :Mason                  : Tool to manage LSP servers

## Git

- [LDR] [g]it             : Menu for Git related functionalities

## Spell Check

> Spell check is on by default in the markdown buffer

- C-s:                    : In insert mode, fix the nearest spelling error and put the cursor back
                            In normal mode, toggle spelling suggestion on the cursor
- [LDR] s t               : Toggle spell checker

## Markdown and LaTeX

- :MarkdownPreviewToggle  : Opens the compiled markdown file in the native browser
- :VimtexCompile          : Start a real-time compilation in the PDF viewer

