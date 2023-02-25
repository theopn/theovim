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

-- FUnction and global var for auto formatting toggle
CODE_FORMAT_STATUS = true
local function code_format_toggle()
  CODE_FORMAT_STATUS = not CODE_FORMAT_STATUS
  -- (code_format_status) ? ("On") : ("Off") Lua plz support conditional ternary op
  vim.notify("Code Auto Format " .. (CODE_FORMAT_STATUS and "On!" or "Off!"))
end

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    -- User command to toggle code format only available when LSP is detected
    vim.api.nvim_create_user_command("CodeFormatToggle", function() code_format_toggle() end,
      { nargs = 0 })

    -- Autocmd for code formatting on the write
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = false }),
      buffer = bufnr,
      callback = function()
        if CODE_FORMAT_STATUS then vim.lsp.buf.format() end
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
    require("lspconfig")[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
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

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
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
    ["<C-[>"] = cmp.mapping.scroll_docs( -4), --> Scroll through the information window next to the item
    ["<C-]>"] = cmp.mapping.scroll_docs(4), --> ^
    ["<C-n>"] = cmp.mapping.complete(), --> Brings up completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }), --> Enable to automatically select the first item without pressing tab
    ["<TAB>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()

        --[[
      -- This gets annoying when you just want to indent. visit
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings to re-enable has_words_before() function
      elseif has_words_before() then
        cmp.mapping.complete()
      --]]
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<S-TAB>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
    {
      { name = 'buffer' },
      { name = 'path' },
    }),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            buffer = "[Buffer]",
            path = "[Path]"
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
-- }}}
