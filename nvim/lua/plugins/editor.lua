local Util = require("lazyvim.util")

return {
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { ";o", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      { ";p", Util.telescope("files"), desc = "Find Files (root dir)" },
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
