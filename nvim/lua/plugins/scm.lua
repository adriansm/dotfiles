return {
  -- the git plugin
  "tpope/vim-fugitive",


  -- a magit clone for Neovim
  {
    "TimUntersberger/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    }
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", desc = "Open current file history view" },
    },
  }
}
