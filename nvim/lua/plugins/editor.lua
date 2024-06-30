local Util = require("lazyvim.util")

return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { ";o", Util.pick("files", { cwd = nil }), desc = "Find Files (cwd)" },
      { ";p", Util.pick("files"), desc = "Find Files (root dir)" },
    },
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["o"] = "open",
        },
      },
    },
  },

  -- Cursor line only for current window (conflicts with neo-tree)
  -- "vim-scripts/CursorLineCurrentWindow",
}
