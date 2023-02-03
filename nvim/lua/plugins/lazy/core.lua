return {
  "folke/lazy.nvim",                      -- Plugin Manager

  -- [[ Perf Plugins ]]
  { "lewis6991/impatient.nvim", lazy = false },
  { "dstein64/vim-startuptime", lazy = false },

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
  {                                       -- Highlight trailing white space
    "ntpeters/vim-better-whitespace",
    init = function()
      vim.g.better_whitespace_ctermcolor = "red"
      vim.g.better_whitespace_guicolor = "red"
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_only_modified_lines = 1
    end
  },
  {
    "alker0/chezmoi.vim",
    init = function()
      vim.cmd[[
        let g:chezmoi#use_external = 1
      ]]
    end
  },
}
