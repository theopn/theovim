# Commonly Used Vim Keybindings

Most of the single-characters or basic bindings (hjkl, webr, u/<C-r>, etc.) are omitted.

## Normal Mode

- C-d, C-u  : Scroll through the file
- C-f, C-b  : Page down/up
- zz        : Center the screen

- [d]elete [a] [w]ord
- [d]elete [t]ill (character)
- dd        : Delete a line

- 0/^, $    : Move to the front (^ moves to the first non-space character)/back of the current line
- %         : Jump to the matching parenthesis, curly braces, brackets, etc

- .         : Repeat the last editing keystroke
- g C-g     : Current buffer word count, etc.
- ZZ        : :update (writes to a file only if there is a change) and quit
              :x works too
- gg=G      : Indent the whole file

- q(letter) : Start recording keystrokes in (letter) register
              @(letter) to repeat marco
              q to exit

### Search and Replace

- :%s/(text)/(replacement)/g  : Replace all
                                :<',>'s/(text)/(replacement)/g can be invoked if you have a selection
- //                          : Repeat last search
- \*                          : Searches the cursor word
- R                           : Continuous replace mode

### Folding

- zc, zo, za                  : Close, open, or toggle one level of folding on the cursor (capital letter for all levels)
- zr/zm                       : Close or open one level of folding throughout the buffer (capital letter for all levels)

## Insert Mode

- C-[               : ESC
- C-v (character)   : Insert character literally (e.g. <TAB>)
- C-n               : Built-in auto-completion menu (C-n, C-p to navigate, C-e to close)

## Visual Mode

- u/U   : Capitalize/uncapitalize current selection
- </>   : Indent/unindent current selection

## Commands

- :qa                 : Close all open windows
- :reg                : Open up the register contents
- "(clipboard-name)p  : Paste the content in the particular register
- :retab              : Replace tab character to space (or vice versa depending on the configuration)

## Tab v.s. Buffer

- :buffer           : List all opened files
- :tab              : List opened "workspaces" holding window layout

- :b (number/name)  : Select the buffer specified by the ID or (partial) file name
- (number) gt       : Select the tab specified by the number

- :enew             : Open a new buffer without a name
- :tabnew           : Open a new tab then execute `:enew`
- :e (file)         : Open a new buffer with the file name
- :tab sb (number)  : Open a new tab with the selected buffer (or the current buffer without selection)

- :bprev/bnext      : Cycles through the buffers
- gt/gT             : Cycles through the tabs
                      :tabprevious/tabnext works too

- :bdelete (number) : Deletes a buffer
- :tabclose         : Closes a tab. Note that tabs will be killed when there is no split pane to display or the current buffer is killed

### Suggested workflow

- Open files using `:e <file>` command. Change between files using `:b <number>` command
  - [Theovim] `<leader>ff` to quickly open a file using the fuzzy finder
  - [Theovim] cycle through buffers quickly using `<leader>,/.` or choose from a menu using `<leader>b`
- If you accumulated buffers that you want to separate, create a tab. Create a window layout, and select buffers for each window using `:b <number>`
  - [Theovim] create a new tab with a selected buffer using `<leader>n`
  - [Theovim] create a split screen using `<leader>-/|`
- Navigate between these "workspaces" (tabs) using gt/gT keybindings
  - [Theovim] jump between tabs using `<leader>1-9`
- When you want to close a buffer, use `:bdelete <number>`
  - [Theovim] `<leader>x` to close a selected buffer
- Close a tab using `:tabclose`, or as I recommend, either kill the last buffer standing or use split pane close binding `<C-w>q` until there is no pane left
  - [Theovim] close split panes using `<leader>q`

