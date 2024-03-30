local M = { "neovim/nvim-lspconfig", }

M.dependencies = {
  "williamboman/mason.nvim",           --> LSP server manager
  "williamboman/mason-lspconfig.nvim", --> Bridge between lspconfig and mason
  { "j-hui/fidget.nvim", opts = {}, }, --> LSP status indicator
  { "folke/neodev.nvim", opts = {}, }  --> Neovim dev environment
}

M.config = function()
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

  -- Autocmd for LSP functionalities
  local theovim_lsp_config_group = vim.api.nvim_create_augroup("TheovimLspConfig", { clear = true, })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = theovim_lsp_config_group,
    callback = function(event)
      --- Inline helper for defining a buffer-scope LSP keymap with a description
      local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- LSP functions with Telescope counterparts
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

      -- No Telescope counterparts
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")

      -- Highlight keyword under the cursor
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = theovim_lsp_config_group,
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = theovim_lsp_config_group,
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- Format command
      vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
      nmap("<leader>F", vim.lsp.buf.format, "[F]ormat")
    end,
  })

  -- Call Mason
  require("mason").setup()

  -- Get nvim-cmp capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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

  -- Call mason-lspconfig to
  -- 1. ensure servers are installed
  -- 2. Set up handlers for each server using the `server` table
  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    -- Separate setup_handlers() function could be used for the same purpose.
    -- Read |mason-lspconfig.setup_handlers()| for more information
    handlers = {
      function(server_name)
        capabilities = capabilities

        -- Use default server config (`{}`) or server-specific config from `server` table
        local server = servers[server_name] or {}
        require("lspconfig")[server_name].setup(server)
      end
    }
  })
end

return M
