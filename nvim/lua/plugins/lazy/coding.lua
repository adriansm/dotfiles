return {
  --
  -- [[ Source Code Editor ]]
  --

  -- Easily add comments
  { "numToStr/Comment.nvim", config = true },

  -- Brackets autopair plugin
  { "windwp/nvim-autopairs", config = true },


  --
  -- [[ Source Code/Text Browsing ]]
  --

  -- Quick navigation using []
  "tpope/vim-unimpaired",

  -- set vim bookmarks
  "MattesGroeger/vim-bookmarks",

  -- Mark/highlight words to analyze faster
  {
    "inkarkat/vim-mark",
    dependencies = { "inkarkat/vim-ingo-library" }
  },

  -- Easy motion like plugin for nvim
  {
    "phaazon/hop.nvim",
    branch = "v1", -- optional but strongly recommended
    config = true,
  },

  -- Quick shortcuts
  "wellle/targets.vim",


  --
  -- [[ Source Control Integration ]]
  --

  -- The git plugin
  "tpope/vim-fugitive",

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.config.gitsigns").setup()
    end,
  },

  -- Easily jump to root of project
  "dbakker/vim-projectroot",
}
