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

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
}
