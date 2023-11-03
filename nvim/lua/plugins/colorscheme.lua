-- tokyonight
return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
    priority = 1000,
  },

  -- VS code color scheme color scheme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Enable transparent background
      transparent = true,

      -- Enable italic comment
      italic_comments = true,
    },
    config = function(_, opts)
      local c = require('vscode.colors').get_colors()
      opts = vim.tbl_extend("force", {
        group_overrides = {
          -- To make nvim-notify happy
          NotifyBackground = { fg=c.vscFront, bg=c.vscBack },
        },
      }, opts or {})
      require("vscode").setup(opts)
    end
  },
}
