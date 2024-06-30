local has_words_before_cursor = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  -- completion
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip, _ = pcall(require, 'luasnip')

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.schedule(function ()
                vim.snippet.jump(1)
              end)
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before_cursor() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.schedule(function ()
                vim.snippet.jump(-1)
              end)
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
        })
    end,
  },

  -- comments
  {
    -- disable mini.comment included from LazyVim
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring"
    },
    event = "VeryLazy",
    config = function(_, opts)
      opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      require("Comment").setup(opts)
    end,
    vscode = true,
  }
}
