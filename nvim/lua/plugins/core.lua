return {
  "folke/lazy.nvim",                      -- Plugin Manager

  -- [[ Perf Plugins ]]
  "lewis6991/impatient.nvim",
  "dstein64/vim-startuptime",

  -- [[ Common Plugins ]]

  "tpope/vim-sensible",                   -- Defaults everyone can agree on
  "tpope/vim-eunuch",                     -- Unix shell commands
  "will133/vim-dirdiff",                  -- Dir diff
  "vim-scripts/CursorLineCurrentWindow",  -- Cursor line only for current window
  "nvim-lua/popup.nvim",                  -- An implementation of the Popup API from vim in Neovim

  {
    "aymericbeaumet/vim-symlink",         -- Handling of symlinks
    dependencies = { "moll/vim-bbye" }
  },
}
