# Version 2023.07.29

Summary:

This version focuses on bug fixes and (more) refactoring after last two refactor update
**Update command was broken in the last update!** Sorry about this, and use:
`$ cd ~/.config/nvim && git pull && cd -`
to manually update Theovim. Afterwards, you can use `:TheovimUpdate`

Details:

- Add a new changelog style
- Add autocmd to close terminal window when exit code is 0
- Add `gx` binding to open URL in the current line (provided by netrw in "stock" Vim, but NvimTree disables netrw)
- Add LSP symbol and server information shortcut to [c]ode [a]tion keybinding
- Fix broken update and help doc commands

Commits:

- [e4798c0] feat(dev): add a commit list generator for dev tool
- [718040a] fix: fix missing desc keys in keybindings defined somewhere other than core.lua
- [a36c19c] refactor(misc): move keybindings in core to where func are created in misc.lua
- [04e2e52] refactor(core): remove custom function for <SPC>n and x bindings
- [37edf4c] feat(util): replace LSPSaga floating terminal feature with nvim built-in
- [0cae2f7] feat(lsp): add symbol and server information to <spc>ca bindings
- [3037852] feat(init): add safeguard around require
- [ffcd83e] feat(core): add autocmd to close term when exit code is 0
- [5d91547] fix(ui): change dashboard table to local instead of global
- [a315c8a] docs(readme): update changelog commands
- [fcdcbb1] refactor(misc): update changelog command with new paths
- [8405677] feat(core): add gx url opening binding
- [95dbcac] docs(changelog): separate changelog to current (CHANGELOG.md) and historic ones
- [8d3a5fd] fix(init): remove stray temp func
- [b3c4024] refactor(misc)!: move theovim features to misc.lua, refactor floating win functions, rename doc folder
- [f98802e] refactor: change some ascii logo
- [ba59508] refactor(misc): move some theovim func to misc.lua
- [58b4e3a] refactor(config): rename config file names

---

EOF
