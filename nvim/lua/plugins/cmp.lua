local prequire = require('utils.common').prequire

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- local feedkey = function(key, mode)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end

--
-- [[ nvim-cmp related plug-in List ]]
--

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",

      -- add vscode-like pictograms to LSP
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      local luasnip = prequire(cmp)

      return {
        completion = {
          autocomplete = false,  -- disable auto-completion
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            if luasnip then
              luasnip.lsp_expand(args.body) -- For `luasnip` users.
            else
              vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users
            end
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c'}),
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
              -- elseif vim.fn["vsnip#available"](1) == 1 then
              --   feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
              -- elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              --   feedkey("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            with_text = false, -- do not show text alongside icons
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          })
        },
        --experimental = {
          --  native_menu = true
          --}
        }
      end,
      config = function(_, opts)
        local cmp = require("cmp")

        cmp.setup(opts)
        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline('/', {
          sources = cmp.config.sources({
            { name = 'nvim_lsp_document_symbol' }
          }, {
            { name = 'buffer' }
          })
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]
      end
  },

  -- For vsnip as snippet manager for LSP completion
  -- { "hrsh7th/cmp-vsnip", requires = { "hrsh7th/vim-vsnip" }}

  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "1.*", build = "make install_jsregexp" },
    }
  },

  -- common snippets for faster development
  {
    "rafamadriz/friendly-snippets",
    config = function ()
      local luasnip = require("utils.common").prequire("luasnip")
      if luasnip then
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    end
  },

  -- function signature for some lsp
  {
    "ray-x/lsp_signature.nvim",
    config = true,
  },

}
