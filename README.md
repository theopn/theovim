# Theovim

![theovim-banner](./assets/theovim-banner.jpg)

Theovim is my Neovim configuration, featuring opinionated base Vim settings, ~30 carefully selected plug-ins, and custom UI components written 100% in Lua.

Some Theovim philosophies that might convince you to use Theovim:

1. Prefer Neovim API and Lua over plug-ins
1. When using plug-ins, keep the stock configuration as much as possible. The plug-in author knows more about the plug-in than I do
1. Comment the code!
1. Avoid duplicate keybindings and features
1. 10 keybindings you can memorize are better than 50 complicated keybindings
1. Keep things minimal

## Dependencies

- **Terminal emulator with true color support (Wezterm, Kitty, Alacritty, iTerm 2, etc.)**
- **Neovim version > 0.8.0**
- **`npm`, `g++` (`gcc-c++`), and `unzip` for `bashls` and `clangd` language server**
- **[NerdFonts](https://www.nerdfonts.com/font-downloads) to render glyphs**
- `git` to update Theovim

## Installation

```bash
# Optional backup
[[ -e ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak
# Install Theovim files in ~/.config/nvim
git clone --depth 1 https://github.com/theopn/theovim.git ~/.config/nvim
```

## Features and Usage

File structure:

```
├── init.lua                        --> Module initializations
└── lua
    │
    ├── config.lua                  --> User configuration
    ├── core.lua                    --> Core functions (opt and keymaps)
    ├── misc.lua                    --> Miscellaneous Theovim features
    ├── plugins.lua                 --> Plug-in table, simple setup(), and Lazy bootstrap
    ├── util.lua                    --> Utilities for float win, vim.ui.select, etc.
    │
    ├── config
    │   └── ...                     --> Long plug-in setup() functions
    │
    ├── lsp
    │   ├── completion.lua          --> nvim-cmp and snippet init
    │   └── lsp.lua                 --> Neovim built-in LSP config and other LSP-related features
    │
    └── ui                          --> Handmade Theovim UI elements
        ├── components.lua          --> Statusline and Winbar modules
        ├── dashboard.lua           --> Cute startup Dashboard
        ├── highlights.lua          --> Custom highlights used by UI components
        ├── statusline.lua          --> Simple global Statusline
        ├── tabline.lua             --> Clean tabline with buffer and tab info
        └── winbar.lua              --> Simple Winbar to complement global Statusline
```

### Keybindings (core.lua)

- Leader (`[LDR]`) key is the space bar (`SPC`)
- `j k` (insert): ESC

- `[LDR] a`: **Select [a]ll**
- `[LDR] /`: Clear the last search and search highlights

Copy and paste:

- `[LDR] y` (visual): Yank to the system clipboard ([unnamedplus](https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings))
- `[LDR] p` (visual): Paste the selection without overriding the default register (reference "leader p demo" below)
- `[LDR] p` (normal): Open a register (similar to clipboard history -- `:h registers`) selection

Buffer navigation:

- `[LDR] b`: **[b]uffer**. Open a buffer list
- `[LDR] [`/`]`: Navigate to prev/next buffers
- `[LDR] k`: **[k]ill buffer**. Delete a buffer. Hit enter to kill the current buffer or type one of the displayed buffer numbers to specify a buffer (reference "leader k demo" below)

Window resizing:

- Theovim does not offer many window resizing/navigation bindings since Vim already has `C-w` keybindings. Familiarize yourself with `C-hjkl`, `C-w` (for navigating to floating windows), `C-w =`, `C-w |`, etc.

- `[LDR] +`/`-`: Increase/decrease the current window height by one-third
- `[LDR] >`/`<`: Increase/decrease the current window width by one-third

Tab navigation:

- `[LDR] t`: **new [t]ab**. Create a new tab. Hit enter to make a new tab with the current buffer or type one of the displayed buffer numbers to specify a buffer (reference "leader k demo" below). If this is confusing, read [my article on Vim workflow](//TODO) to learn about the Vim tab system
- `[LDR] q`: **[q]uit**. Close the current tab. (you cannot close the one and only tab. Use `C-w q` or `:q`)
- `[LDR] 1`-`5`: Navigate to tab number 1 - 5

Overridden keybindings: These are Vim keybindings overridden by Theovim.

- `gx`: Open URL in the current line (error notification if no URL is found)
    - In Vim, this keybinding is provided by `netrw`, which is disabled in Theovim for a better file management plug-in
- `n`/`N`: Cycle through search results and center the screen
    - Vim does not center the screen by default

**Demo**:

<details>
  <summary>Leader k Demo</summary>

  ![ldr-k-demo](./assets/ldr-k-demo.gif)
</details>

<details>
  <summary>Leader p Demo</summary>

  ![ldr-p-demo](./assets/ldr-p-demo.gif)
</details>

### Commands (core.lua)

Many of these features are accessible through `[LDR] m` keybinding (reference "Miscellaneous Theovim Features" section).

- `:TrimWhiteSpace`: Remove trailing whitespaces
- `:ShowChanges`: Show the difference between the saved file and the current Vim buffer using shell commands
- `:CD`: You might launch Vim in `foo` directory and open `foo/bar/baz/file.txt`. Use this command to change the working directory to `baz` (to narrow the Telescope search down, etc.). It only affects the current buffer. You can change the CWD and relative file path in the Statusline

### Options (core.lua)

- By default, tab characters are set to 2 spaces. For some filetypes, the value of `tabstop` will change (e.g., Java has a tab width of 4 characters)

- Tab character                 : Renders as `⇥ `
- Leading spaces (indentation)  : Renders as `│ `
- Trailing space                : Renders as `␣`
- Non-breaking space            : Renders as `⍽`
- Beginning of a wrapped line   : Renders as `↪`

- In some filetype, `colorcolumn` (highlights a specific column) is enabled based on its typical language convention. For example, in C/C++ buffers, the 80th column will be highlighted so that you don't exceed 80 characters per line

You can override any of the options in `core.lua` in your `config.lua`:

```lua
-- Example of overriding options in config.lua
vim.opt.scrolloff = 10 --> show at least 10 lines above/below from the current cursor, which is 7 lines by default
vim.opt.confirm = false --> turn off confirm prompt when quitting with unsaved buffer, which is on by default
```

### Spell Check (core.lua)

- Spell check is supported for English using the Vim built-in spell check feature. Use the `:h spell` for more information
- Spell check is enabled in text buffers (`*.txt`, `*.md`, `*.tex`, etc.). You can use toggle spell check binding (or `:set spell`/ `:set spell!` to toggle spell check globally) to turn spell check on other buffers

- `C-s`: **[s]pell**
    - (insert): Fix the nearest spelling error and put the cursor back
    - (normal): Bring up spell suggestions for the word under the cursor
- `[LDR] s t`: **[s]pell [t]oggle**. Toggle spell check

### Terminal (core.lua -- autocmd, misc.lua -- keybinding)

- `[LDR] z`: **[z]sh**. Prompts you for the location where the new terminal window is to be launched (bottom, left, or right third, floating, new tab)
- Theovim uses Neovims built-in terminal emulator. For more information, `:h terminal`
- There are autocmd to:
    1. Automatically start the insert mode when terminal buffers open. Use ESC to escape to the normal mode
    2. Closes the terminal if the exit code is 0. Otherwise, you will get a notification, and the terminal window will persist until you hit enter

### Markdown and LaTeX (plugins.lua)

- `:MarkdownPreviewToggle`: Toggle GitHub-style real-time markdown preview in your default browser
- `:VimtexCompile`: Toggle LaTeX compile and real-time preview on buffer save. You should specify and prepare the PDF viewer of your choice in `config.lua`. Currently, [Skim](https://skim-app.sourceforge.io/) (for MacOS) or [Zathura](https://pwmt.org/projects/zathura/) for Linux/MacOS are supported

```lua
vim.g.vimtex_view_method = "skim" --> or "zathura"
```

### LSP (lsp.lua)

When Winbar says you have an LSP server running in the buffer, you are in for a treat! Theovim uses the Neovim built-in LSP to provide modern IDE features. The followings are keybindings related to LSP features:

- `[LDR] c a`: **[c]ode [a]ction**. Open the menu for LSP features
- `[LDR] c d`: **[c]ode [d]oc**. Open a hover doc for the cursor item
- `[LDR] c r`: **[c]ode [r]name**. Rename the cursor item
- `[LDR] c e`: **[c]ode [e]rror**. 
- `[LDR] c p`: **[c]ode [p]rev**. 
- `[LDR] c n`: **[c]ode [n]ext**. 

Many LSP servers detect information from your code as well as system-wide libraries and project files in the same directory. If the LSP doesn't work as you wish, consult the LSP server documentation.

Diagnostics:

Whenever an LSP server detects an error or has a suggestion for your code, Theovim will display the diagnostics status in your Winbar. Four types of diagnostics are: "Error", "Warning", "Hint", and "Info". For example, the below image is the `clangd` LSP server displaying warnings and an error for my C code.

![lsp-diagnostics-example.jpg](./assets/lsp-diagnostics-example.jpg)

You can get a comprehensive list of diagnostics in the current buffer using `[LDR] c e`. You can navigate to nearest diagnostics using `[LDR] c p`/`n`.

Completion

//TODO
![lsp-completion-example.jpg](./assets/lsp-completion-example.jpg)

Theovim offers completion engines for LSP buffers as well as general text editing.

- `C-j`/`k`: Scroll through completion items
- `TAB`/`S-TAB`: Scroll through completion items
- `RET`: Confirm the selection
    - Or, once a completion item gets rendered on screen using `TAB` you can continue typing without hitting `RET`
- `C-[`/`]`: Scroll through completion documentation
- `C-e`: Close the completion window
- `C-n`: Manually open the completion menu

The order of completion item detection:

1. LSP engine (if applicable)
2. LuaSnip snippets
3. Buffer words
4. Path completion

There is also a Vim command line completion.

//TODO
![cmd-completion-example.jpg](./assets/cmd-completion-example.jpg)

Formatting:

- Linter (code formatter) is available for some buffers when LSP servers provide a formatter (`vim.lsp.buf.format()`)
- You can track the status of Linter in the Statusline component (reference the "Built-in UI" section below).
- When Linter is on, it will format the code every time you save. **You can turn this off using `:LspLinterToggle`**
    - `LspLinterToggle` is a global option, meaning if you turn on/off Linter, it will be applied to all buffers
    - It also does not have a memory, meaning when you turn Linter off and relaunch Neovim, it will be on again
    - To change the default behavior, add the following option to `config.lua`

```lua
vim.g.linter_status = false
```

Adding a new LSP server: 

- Theovim automatically installs [bashls](https://github.com/bash-lsp/bash-language-server), [clangd](https://github.com/clangd/clangd), [lua_ls](https://github.com/LuaLS/lua-language-server), [pylsp](https://github.com/python-lsp/python-lsp-server), and [texlab](https://github.com/latex-lsp/texlab)
- Browse `:Mason` or [nvim-lspconfig server list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) for available LSP servers. Use `:MasonInstall <lsp-name>` and `:MasonUninstall <lsp-name>` commands to install/uninstall LSP server

Following features are accessible through `[LDR] c a`:

- Code action: Get a suggestion menu for LSP diagnostics
- References: See where the variable/function under the cursor was used
- Symbols: List all variables, functions, and other components that the LSP server detects for a quick navigation
- **To stop LSP server, use `:LspStop`**


---
BELOW DOC IS INCOMPLETE


### Telescope (/config/fuzzy.lua)

- Reference the full README in //TODO
- File browser (`<LDR>fb`): 
- Find Files (`<LDR>ff`): Fuzzy finder for files in the current directory and subdirectories. Optionally, install [fd](https://github.com/sharkdp/fd) for better performance, `.gitignore` support, and other fd features.

### Plug-in List

Theovim has 27 plug-ins (+ Lazy).

Dependencies:

- `nvim-lua-plenary.nvim`: Lua function library for Neovim
- `nvim-tree/nvim-web-devicons`: Icons based on filetype

UI:

- `folke/tokyonight.nvim`: Theovim's colorscheme
- `rcarriga/nvim-notify`: Prettier notification

Syntax, file, search:

- `nvim-treesitter/nvim-tresitter`: Incremental highlighting
- `nvim-telescope/telescope.nvim`: Fuzzy finder
- `nvim-telescope/telescope-file-browser.nvim`: File browser extension for Telescope
- `kyazdan142/nvim-tree.lua`: File tree
- `stevearc/oil.nvim`: Manage files like Vim buffer
- `lewis6991/gitsigns.nvim`: Git information
- `lukas-reineke/indent-blankline.nvim`: Indentation guide
- `windwp/nvim-autopairs`: Autopair for `()`, `[]`, etc.
- `terrortylor/nvim-comment`: Comment code block
- `norcalli/nvim-colorizer.lua`: Color highlighting

LSP:

- `neovim/nvim-lspconfig`: Built-in LSP engine
- `williamboman/mason.nvim`: LSP server manager
- `williamboman/mason-lspconfig.nvim`: Bridge b/w lspconfig and Mason
- `theopn/friendly-snippets`: VS Code style snippet collection
- `L3MON4D3/LuaSnip`: Snippet engine that accepts VS Code style snippets
- `saadparwiz1/cmp_luasnip`: Bridge b/w nvim cmp and LuaSnip
- `hrsh7th/cmp-nvim-lsp`: nvim-cmp source for LSP engine
- `hrsh7th/cmp-buffer`: nvim-cmp source for buffer words
- `hrsh7th/cmp-path`: nvim-cmp source for file path
- `hrsh7th/cmp-cmdline`: nvim-cmp source for :commands
- `hrsh7th/nvim-cmp`: Completion engine

Markdown:

- `iamcco/markdown-preview.nvim`: markdown preview
- `lervag/vimtex`: LaTeX integration

### Built-in UI Elements (/ui)

Startup dashboard: launches when Neovim is opened with no argument. You can operate each function using `jk` (or arrow keys) and enter key. One of ASCII arts of my cat Oliver is randomly selected.

//TODO image of the dashboard in collapsible HTML element

Tabline:



Statusline: from left to right,

// image

```
| Mode | current working dir | file name [modified statu] | git information | ... | Linter status | Filetype | File format and encoding | line:column location in the buffer
```

Winbar:

### Miscellaneous Theovim Features (misc.lua, util.lua)

- [LDR] [g]it: Menu for Git related functionalities (status, diff, commits, etc.)
- [LDR] [m]isc: Menu for miscellaneous Theovim features

- Notepad
- TrimWhiteSpace
- ShowChanges
- Built-in documentation

- `:TheovimHelp` contains all the custom commands and shortcuts
- `:TheovimUpdate` updates the latest changes to Theovim by pulling the changes and running update utilities
- `:TheovimChangelog` for the current version information and latest changes

## Other Things

- Join (informal) Theovim user group [Discord server](https://discord.gg/er5EqNdkhH)

