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

--------------------------------------------------------- LSP  ---------------------------------------------------------

-- Setting LSP look
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    title = "Hover"
  }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
    title = "Signature Help"
  }
)

---
--- A function to attach for a buffer with LSP capabilities
---@param _ string Client name, used by lspconfig internally
---@param bufnr number buffer number
--]]
local on_attach = function(_, bufnr)
  --- Inline helper for defining a buffer-scope LSP keymap with a description
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Frequently used keybindings
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Listing features w Telescope counterparts
  local status, builtin = pcall(require, "telescope.builtin")
  if status then
    local telescope_opt = { jump_type = "tab" } --> Spawn selection in a new tab
    -- Navigation
    nmap("gd", function() builtin.lsp_definitions(telescope_opt) end, "[G]oto [D]efinition")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", function() builtin.lsp_type_definitions(telescope_opt) end, "Type [D]efinition")
    -- Symbols
    nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  else
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
    nmap("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
  end

  -- Lesser used features
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Format command
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
  nmap("<leader>f", vim.lsp.buf.format, "[F]ormat")
end

-- Let the LSP setup begin
require("mason").setup()
require("mason-lspconfig").setup()

-- Define servers and server-specific config
local servers = {
  bashls = {},
  clangd = {},
  pylsp = {},
  texlab = {},
  -- html = { filetypes = { "html", "twig", "hbs"} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}

-- Neovim dev environment
require("neodev").setup()

-- Get nvim-cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Install Mason servers
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

-- Setup mason-lspconfig handler
mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

