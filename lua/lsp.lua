--- lsp.lua
--- $ figlet -f larry3d theovim
---  __    __
--- /\ \__/\ \                              __
--- \ \ ,_\ \ \___      __    ___   __  __ /\_\    ___ ___
---  \ \ \/\ \  _ `\  /'__`\ / __`\/\ \/\ \\/\ \ /' __` __`\
---   \ \ \_\ \ \ \ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \
---    \ \__\\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
---     \/__/ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
---
--- Configuration for:
--- - Neovim built-in diagnostic framework
--- - Neovim built-in LSP engine enabled by
---   - lspconfig
---   - Mason
---   - Mason-lspconfig
--- - Neovim built-in completion engine enabled by
---   - nvim-cmp
---   - Luasnip
---

------------------------------------------------------ DIAGNOSTIC ------------------------------------------------------

-- Diagnostic formatting and look
vim.diagnostic.config({
  float = {
    border = "rounded",
    format = function(diagnostic)
      -- "ERROR (line n): message"
      return string.format("%s (line %i): %s",
        vim.diagnostic.severity[diagnostic.severity],
        diagnostic.lnum + 1,
        diagnostic.message)
    end
  },
  update_in_insert = false,
})

-- Keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float({
      header = "Buffer Diagnostics",
      scope = "buffer",
    })
  end,
  { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

