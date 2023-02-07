-- tokyonight
return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
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
  },
}
