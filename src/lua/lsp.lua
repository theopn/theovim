--[[
" figlet -f stacey theovim-lsp
" ________________________________ _____________________   ______________
" 7      77  7  77     77     77  V  77  77        77  7   7     77     7
" !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  ||  |   |  ___!|  -  |
"   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  ||  !___!__   7|  ___!
"   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  ||     77     ||  7
"   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!!_____!!_____!!__!
--]]

-- List of LSP server used later
-- MasonInstall bash-language-server, clangd, css-lsp, html-lsp, lua-language-server, python-lsp-server, remark-language-server, sqlls
-- Always check the memory usage of each language server. :LSpInfo to identify LSP server and use "sudo lsof -p PID" to check for associated files
-- Blacklist: ltex-ls (java process running in the bg for each instance of markdown files)
local server_list = {
  "bashls", "clangd", "cssls", "html", "pylsp", "sqlls",
}

-- {{{ Call lspconfig settings
local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end
-- }}}

-- {{{ nvim-cmp setup
-- Table for icons
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Helper function for TAB completion
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local cmp = require "cmp"

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item(), --> <C-n>
    ["<C-k>"] = cmp.mapping.select_prev_item(), --> <C-p>
    ["<C-e>"] = cmp.mapping.abort(), --> Close the completion window
    ["<C-[>"] = cmp.mapping.scroll_docs(-4), --> Scroll through the information window next to the item
    ["<C-]>"] = cmp.mapping.scroll_docs(4), --> ^
    ["<C-Space>"] = cmp.mapping.complete(), --> Brings up completion window without
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) --> <C-n> if completion window is open
      elseif check_backspace() then
        fallback() --> Default action (tab char or shiftwidth) if the line is empty
      else
        cmp.complete() --> Open completion window. Change it to fallback() if you want to insert tab in between lines
      end
    end, { 'i', 's' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
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

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }}}

-- {{{ Language Server Settings
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set({ 'n' }, "<Space>cf", "<CMD> lua vim.lsp.buf.format()<CR>", { noremap = true })
    vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format() end, { nargs = 0 })
  end
end

for _, v in ipairs(server_list) do
  nvim_lsp[v].setup { capabilities = capabilities, on_attach = on_attach }
end

nvim_lsp.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostircs = {
        globals = { "vim" }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      },
    },
  },
}
-- }}}

-- {{{ Trouble Settings
--[[
require("trouble").setup {
  mode = "document_diagnostics",
}
--]]
-- }}}
