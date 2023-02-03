return {
  --
  -- [[ Terminal Integration Plugins ]]
  --

  -- Go to line when opening with "vim file:line"
  "wsdjeg/vim-fetch",

  -- Tmux integration
  "christoomey/vim-tmux-navigator",

  -- Split resizing/navigation
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local splits = require("smart-splits")
      vim.keymap.set("n", "<A-h>", splits.resize_left)
      vim.keymap.set("n", "<A-j>", splits.resize_down)
      vim.keymap.set("n", "<A-k>", splits.resize_up)
      vim.keymap.set("n", "<A-l>", splits.resize_right)
    end
  },

  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup {
        max_length = 0,  -- Maximum length of selection (0 for no limit)
        silent = false,  -- Disable message on successful copy
        trim = false,    -- Trim text before copy
      }
      function copy()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
          require("osc52").copy_register("")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", {callback = copy})
    end
  },

}
