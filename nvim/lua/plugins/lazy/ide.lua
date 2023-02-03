return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("plugins.config.telescope").setup()
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = true,
  },

  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      {"<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree" }
    },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.config.nvim-tree").setup()
    end
  },

  {                                       -- Display possible key bindings
    "folke/which-key.nvim",
    config = true,
  },

  -- Legendary
  {
    "mrjones2014/legendary.nvim",
    keys = { "<C-p>" },
    config = function()
      require("plugins.config.legendary").setup()
    end,
    dependencies = { "stevearc/dressing.nvim" },
  }
}
