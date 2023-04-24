--[[
" figlet -f stacey theovim-lsp
" ________________________________ _____________________   ______________
" 7      77  7  77     77     77  V  77  77        77  7   7     77     7
" !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  ||  |   |  ___!|  -  |
"   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  ||  !___!__   7|  ___!
"   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  ||     77     ||  7
"   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!!_____!!_____!!__!
--]]
--

-- List of LSP server used later
-- Always check the memory usage of each language server. :LSpInfo to identify LSP server and use "sudo lsof -p PID" to check for associated files
-- Blacklist: ltex-ls (java process running in the bg for each instance of markdown files)
local server_list = {
  "bashls", "clangd", "lua_ls", "pylsp",
}

local theo_server_recommendations = {
  "cssls", "html", "sqlls", "texlab"
}

-- {{{ Call lspconfig settings
local status, lspconfig = pcall(require, "lspconfig")
if (not status) then return end
-- }}}

-- {{{ Language Server Settings
-- Capabilities and on_attach function that will be called for all LSP servers
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Global var for auto formatting toggle
vim.g.linter_status = true

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    -- User command to toggle code format only available when LSP is detected
    vim.api.nvim_create_user_command("LinterToggle", function()
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

-- Let Mason-lspconfig handle LSP setup
require("mason-lspconfig").setup {
  ensure_installed = server_list,
  automatic_installation = true,
}

require("mason-lspconfig").setup_handlers({
  -- Default handler
  function(server_name)
    require("lspconfig")[server_name].setup({ capabilities = capabilities, on_attach = on_attach, })
  end,
  -- Lua gets a special treatment
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
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
