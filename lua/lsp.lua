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
-- Configuration for:
-- - Neovim built-in diagnostic framework
-- - Neovim built-in LSP engine enabled by
--   - lspconfig
--   - Mason
--   - Mason-lspconfig
-- - Neovim built-in completion engine enabled by
--   - nvim-cmp
--   - Luasnip
--]]

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

--[[ on_attach()
-- A function to attach for a buffer with LSP capabilities
--
-- @arg _: Client name, used by lspconfig internally
-- @arg bufnr: buffer number
--]]
local on_attach = function(_, bufnr)
  -- Format command
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })

  --[[ nmap()
  -- @brief Inline helper for defining a buffer-scope LSP keymap with a description
  --]]
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>F", vim.lsp.buf.format, "[F]ormat")

  -- Frequently used keybindings
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Listing features w Telescope counterparts
  local status, builtin = pcall(require, "telescope.builtin")
  if status then
    -- Navigation
    nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
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
end

-- Let the LSP setup begin
require("mason").setup()

-- Define servers and server-specific config
local servers = {
  bashls = {},
  clangd = {},
  pyright = {},
  texlab = {},
  -- html = { filetypes = { "html", "twig", "hbs"} },

  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" } --> Make diagnostics tolerate vim.fun.stuff
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

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

-- Neovim dev environment
require("neodev").setup()

------------------------------------------------------ COMPLETION ------------------------------------------------------

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Completion icons to be used later
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

-- Lazy load Luasnip
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),

    ["<C-e>"] = cmp.mapping.abort(),

    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<C-Space>"] = cmp.mapping.complete({}),

    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump() --> use tab to jump completed function param
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
    {
      { name = "buffer" },
      { name = "path" },
    }
  ),

  -- UI customization
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- Completion formatting
  formatting = {
    format = function(entry, vim_item)
      -- Append kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

      -- Source
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
    end
  },
})

-- cmp-cmdline setup
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
