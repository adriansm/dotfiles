local M = {}
local prequire = require('utils.common').prequire

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

function M.setup()
  local cmp = prequire('cmp')
  local lspkind = prequire('lspkind')

  if not cmp or not lspkind then
    return
  end

  local luasnip = prequire(cmp)

  cmp.setup({
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
          luansnip.jump(-1)
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
  })

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

return M
