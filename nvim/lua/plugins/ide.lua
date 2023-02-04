return {
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = true,
  },

  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    keys = {
      {"<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree" }
    },
    opts = {
      renderer = {
        icons = {
          glyphs = {
            default = '',
            symlink = '',
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "凜",
              untracked = "",
              deleted = "",
              ignored = "◌"
            },
            folder = {
              arrow_open = "",
              arrow_closed = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            }
          }
        }
      }
    },
  },

  {                                       -- Display possible key bindings
    "folke/which-key.nvim",
    config = true,
  },

  -- Legendary
  {
    "mrjones2014/legendary.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    opts = {
      include_builtin = true,
      auto_register_which_key = true,
    },
    keys = {
      {"<C-p>", "<cmd>lua require('legendary').find()<CR>"}
    },
  }
}

