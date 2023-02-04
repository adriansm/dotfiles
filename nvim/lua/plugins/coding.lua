local prequire = require('utils.common').prequire

return {
  --
  -- [[ Source Code Editor ]]
  --

  -- Easily add comments
  { "numToStr/Comment.nvim", config = true },

  -- Brackets autopair plugin
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      ts_config = {
        lua = {'string'},  -- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false -- don't check treesitter on java
      }
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      local cmp = prequire('cmp')
      if cmp then
        -- register completion event
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
      end
    end
  },


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
    keys = {
      { "s", "<cmd>HopChar1<CR>", desc = "Quick hop with one char" },
      { ";j", "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>",
        mode = {"n", "v"}, desc = "Hop to lines before cursor" },
      { ";k", "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>",
        mode = {"n", "v"}, desc = "Hop to lines after cursor" },
      { ";l", "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>",
        mode = {"n", "v"}, desc = "Hop to words after cursor" },
      { ";h", "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>",
        mode = {"n", "v"}, desc = "Hop to words before cursor" },
    },
  },

  -- Quick shortcuts
  "wellle/targets.vim",
}
