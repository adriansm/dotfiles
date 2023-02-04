
return {
  -- Treesitter configurations and abstraction layer for Neovim
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = false,
          disable = {},
        },
        ensure_installed = {
          "c",
          "cpp",
          "lua",
          "vim",
          "help",
          "python",
          "toml",
          "json",
          "yaml",
          "html"
        },
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    name = "treesitter-context",
    config = true,
  },
}
