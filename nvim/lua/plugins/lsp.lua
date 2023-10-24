return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@diagnostic disable-next-line: missing-parameter
        vim.list_extend(opts.ensure_installed, { "lua-language-server" })
      end
      return opts
    end,
  },

  -- render diagnostics using virtual lines
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
    end
  },

  -- Standalone UI for nvim-lsp progress. Eye candy for the impatient
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = true,
  }
}
