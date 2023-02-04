return {
  -- start screen
  "mhinz/vim-startify",

  -- cursor jump
  "DanilaMihailov/beacon.nvim",

  -- VS code color scheme color scheme
  {
    "Mofiqul/vscode.nvim",
    priority = 100,
    opts = {
      -- Enable transparent background
      transparent = true,

      -- Enable italic comment
      italic_comments = true,
    }
  },

  "marko-cerovac/material.nvim",
  "navarasu/onedark.nvim",
  "tiagovla/tokyodark.nvim",
}
