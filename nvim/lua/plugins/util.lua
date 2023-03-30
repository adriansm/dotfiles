return {
  -- Go to line when opening with "vim file:line"
  "wsdjeg/vim-fetch",

  -- Split resizing/navigation
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      "<M-Left>",
      "<M-Down>",
      "<M-Up>",
      "<M-Right>",
      "<C-h>",
      "<C-j>",
      "<C-k>",
      "<C-l>",
    },
    config = function()
      local splits = require("smart-splits")
      local map = vim.keymap.set

      map("n", "<M-Left>", splits.resize_left, { desc = "Resize window to the left" })
      map("n", "<M-Down>", splits.resize_down, { desc = "Resize window downwards" })
      map("n", "<M-Right>", splits.resize_right, { desc = "Resize window to the right" })
      map("n", "<M-Up>", splits.resize_up, { desc = "Resize window upwards" })

      map("n", "<C-h>", splits.move_cursor_left, { desc = "Go to left window" })
      map("n", "<C-j>", splits.move_cursor_down, { desc = "Go to lower window" })
      map("n", "<C-k>", splits.move_cursor_up, { desc = "Go to upper window" })
      map("n", "<C-l>", splits.move_cursor_right, { desc = "Go to right window" })
    end,
  },

  -- copy text to the system clipbard using the ANSI OSC52 Sequence
  {
    "ojroques/nvim-osc52",
    event = "TextYankPost",
    config = function(_, opts)
      local function copy()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
          require("osc52").copy_register("")
        end
      end

      require("osc52").setup(opts)
      vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
    end,
  },

  -- open files from a terminal buffer in current neovim instance
  {
    'willothy/flatten.nvim',
    config = true,
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
}
