--[[ completion.lua
-- $ figlet -f computer theovim
-- eeeee e   e eeee eeeee ee   e e  eeeeeee
--   8   8   8 8    8  88 88   8 8  8  8  8
--   8e  8eee8 8eee 8   8 88  e8 8e 8e 8  8
--   88  88  8 88   8   8  8  8  88 88 8  8
--   88  88  8 88ee 8eee8  8ee8  88 88 8  8
--
-- Configuration for Nvim-cmp and snippets. Extension of lsp.lua
--]]
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Completion icons
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#completion-kinds
local kind_icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = "了 ",
  EnumMember = " ",
  Field = "󰜢 ",
  File = " ",
  Folder = " ",
  Function = "ƒ ",
  Interface = "󰜰 ",
  Keyword = "󰌆 ",
  Method = "ƒ ",
  Module = "",
  Property = " ",
  Snippet = " ",
  Struct = " ",
  Text = " ",
  Unit = " ",
  Value = "󰎠 ",
  Variable = " ",
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item(),         --> <C-n>
    ["<C-k>"] = cmp.mapping.select_prev_item(),         --> <C-p>
    ["<C-e>"] = cmp.mapping.abort(),                    --> Close the completion window
    ["<C-[>"] = cmp.mapping.scroll_docs(-4),            --> Scroll through the information window next to the item
    ["<C-]>"] = cmp.mapping.scroll_docs(4),             --> ^
    ["<C-n>"] = cmp.mapping.complete(),                 --> Brings up completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }), --> True to automatically select the first item without pressing tab

    -- Setting up tab behavior
    ["<TAB>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        --elseif has_words_before() then
        --cmp.mapping.complete()
        -- This gets annoying when you just want to indent
        -- visit https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings to re-enable has_words_before() function
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<S-TAB>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources(
  -- Ordered by priority
    {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "nvim_lua" },
    },
    -- Separate code related completion and buffer/path
    {
      { name = "buffer" },
      { name = "path" },
    }
  ),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[NvimAPI]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },
})

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
