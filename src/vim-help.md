# Commonly Used Vim Keybindings

Most of the single character or really basic bindings (hjkl, webr, u/<C-r> etc) are omitted.

## Normal Mode

- <C-d>, <C-u>: Scroll through the file
- <C-f>, <C-b>: Page down/up

- daw: "Delete A Word"
- dt<char>: "Delete Till <char>"
- dd: Delete a line

- 0/$: Move to front/back of the current line
- %: Jump to the matching parenthesis, curly braces, brackets, etc

- .: Repeat last command
- g<C-g>: Current buffer word count, etc.
- ZZ: :x
- gg=G: Indent the whole file

- q<letter>: Start recording key strokes in <letter> register
             @<letter> to repeat marco
             q to exit

### Search and Replace

- :%s/text/replacement/g, :<',>'s/text/replacement: Replace
- //: Last search
- *: Searches the cursor word
- R: Continuous replace mode

### Folding

- zc/zo/za: Close, open, or toggle one level of folding on the cursor (capital letter for all levels)
- zr/zm: Close or open one level of folding throughout the buffer (capital letter for all levels)

## Insert Mode

- <C-[>: ESC
- <C-v><char>: Insert character literally (e.g. <TAB>)
- <C-n>: Built-in auto-completion menu (<C-n>, <C-p> to navigate, <C-e> to close)

## Visual Mode

- u/U: Capitalize/uncapitalize current selection
- </>: Indent/unindent current selection

## Commands

- :enew: New buffer without a name
- :reg: Open up the register contents
- "<clipboard-name>p: Paste the content in the particular register
- :retab: Replace tab character to space (or vice versa depending on the configuration)

