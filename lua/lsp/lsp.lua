--[[ lsp.lua
-- $ figlet -f larry3d theovim
--  __    __
-- /\ \__/\ \                              __
-- \ \ ,_\ \ \___      __    ___   __  __ /\_\    ___ ___
--  \ \ \/\ \  _ `\  /'__`\ / __`\/\ \/\ \\/\ \ /' __` __`\
--   \ \ \_\ \ \ \ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \
--    \ \__\\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
--     \/__/ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
--
-- Configuration for Neovim's built-in LSP
--]]
local util = require("util")
local status, lspconfig = pcall(require, "lspconfig")
if (not status) then return end
local mason_lspconfig = require("mason-lspconfig")

--[[ set_diagnostics_config()
-- Initialize Vim diagnostics settings
--]]
local function set_diagnostics_config()
  vim.diagnostic.config({
    float = {
      border = "rounded",
      format = function(diagnostic)
        -- "ERROR (line n): message"
        return string.format("%s (line %i): %s",
          vim.diagnostic.severity[diagnostic.severity],
          diagnostic.lnum,
          diagnostic.message)
      end
    },
  })
end

--[[ set_lsp_keymaps()
-- Initialize LSP keymaps for LOCAL BUF. Isolated as a separate func to only be called in LSP buffers
--]]
local function set_lsp_keymaps()
  vim.keymap.set('n', "<leader>cd", function() vim.lsp.buf.hover() end,
    { buffer = true, noremap = true, silent = true, desc = "[c]ode [d]oc: open hover doc for the cursor item" })
  vim.keymap.set('n', "<leader>cr", function() vim.lsp.buf.rename() end,
    { buffer = true, noremap = true, silent = true, desc = "[c]ode [r]enme: rename the cursor item" })
  vim.keymap.set('n',
    "<leader>ce",
    function()
      vim.diagnostic.open_float({ header = "Buffer Diagnostics", scope = "buffer" })
    end,
    { buffer = true, noremap = true, silent = true, desc = "[c]ode [e]rror: open diagnostics pop-up for the buffer" })
  vim.keymap.set('n', "<leader>cp", function() vim.diagnostic.goto_prev() end,
    { buffer = true, noremap = true, silent = true, desc = "[c]ode [p]rev: navigate to previous error" })
  vim.keymap.set('n', "<leader>cn", function() vim.diagnostic.goto_next() end,
    { buffer = true, noremap = true, silent = true, desc = "[c]ode [n]ext: navigate to next error" })
end

--[[ on_attach()
-- A function to attach for a buffer with LSP capabilities
-- List of features:
--   - Provide a "LinterToggle" user command
--   - If conditions are met, format the buffer before write
--
-- @arg client: name of the client name used by Neovim
-- @arg bufnr: buffer number used by Neovim
--]]
local on_attach = function(client, bufnr)
  -- Basic settings
  set_diagnostics_config()
  set_lsp_keymaps()
  -- Global var for auto formatting toggle
  if not vim.g.linter_status then vim.g.linter_status = true end
  if client.server_capabilities.documentFormattingProvider then
    -- User command to toggle code format only available when LSP is detected
    vim.api.nvim_create_user_command("LspLinterToggle", function()
        vim.g.linter_status = not vim.g.linter_status
        print(string.format("Linter %s!", (vim.g.linter_status) and ("on!") or ("off!")))
      end,
      { nargs = 0 })

    -- Autocmd for code formatting on the write
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = false }),
      buffer = bufnr,
      callback = function()
        if vim.g.linter_status then vim.lsp.buf.format() end
      end
    })
  end
end

-- List of LSP server used later
-- Always check the memory usage of each language server. :LSpInfo to identify LSP server
-- and use "sudo lsof -p PID" to check for associated files
local server_list = {
  "bashls", "clangd", "lua_ls", "pylsp", "texlab",
}

-- nvim_cmp capabilities
local cmp_capability = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Let Mason-lspconfig handle LSP setup
mason_lspconfig.setup {
  ensure_installed = server_list,
  automatic_installation = true,
}

mason_lspconfig.setup_handlers({
  -- Default handler
  function(server_name)
    lspconfig[server_name].setup({ capabilities = cmp_capability, on_attach = on_attach, })
  end,
  -- Lua gets a special treatment
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = cmp_capability,
      on_attach = on_attach,
      settings = {
        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
          diagnostics = {
            globals = { "vim" } --> expose the LSP to vim.all.the.fun.stuff
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
})
-- }}}

-- Custom LSP menu
local lsp_options = {
  ["1. Code Action"]                      = function() vim.lsp.buf.code_action() end,
  ["2. References"]                       = function() vim.lsp.buf.references() end,
  ["3. Symbols"]                          = function() vim.lsp.buf.document_symbol() end,
  ["4. Linter (Code Auto Format) Toggle"] = "LspLinterToggle",
  ["5. LSP Server Information"]           = "LspInfo",
}
local lsp_menu = function()
  if #(vim.lsp.get_active_clients({ bufnr = 0 })) == 0 then
    vim.notify_once("There is no LSP server attached to the current buffer")
  else
    util.create_select_menu("Code action to perform at the current cursor", lsp_options)() --> Extra paren to execute!
  end
end
vim.keymap.set('n', "<leader>ca", lsp_menu,
  { noremap = true, silent = true, desc = "[c]ode [a]ction: open menu for LSP features" })
