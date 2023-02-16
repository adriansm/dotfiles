return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local options = vim.tbl_deep_extend("force", opts or {}, {
        indent = {
          disable = { "c", "cpp" },
        }
      })

      if type(options.ensure_installed) == "table" then
        vim.list_extend(options.ensure_installed, { "c", "cpp" })
      end

      return options
    end,
  },
}
