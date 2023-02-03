return {

  -- Collection of configurations for the built-in LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/nvim-lsp-installer",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/neoconf.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      require("plugins.config.lspconfig").setup()
    end,
  },

  {
    "kosayoda/nvim-lightbulb",
    opts = {
      ignore = { "null-ls" },
      autocmd = { enabled = true },
    }
  },

  -- Code Action menu for lsp
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  },

  -- Treesitter configurations and abstraction layer for Neovim
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("plugins.config.treesitter").setup()
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    name = "treesitter-context",
    config = true,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    config = function()
      require("plugins.config.cmp").setup()
    end
  },

  "onsails/lspkind-nvim",

  -- For vsnip as snippet manager for LSP completion
  -- { "hrsh7th/cmp-vsnip", requires = { "hrsh7th/vim-vsnip" }}

  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "1.*", build = "make install_jsregexp" },
    }
  },

  -- common snippets for faster development
  {
    "rafamadriz/friendly-snippets",
    config = function ()
      local luasnip = require("utils.common").prequire("luasnip")
      if luasnip then
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    end
  },

  -- function signature for some lsp
  {
    "ray-x/lsp_signature.nvim",
    config = true,
  },

  {
    "j-hui/fidget.nvim",                      -- nvim-lsp progress. Eye candy for the impatient
    event = "BufReadPre",
    config = true,
  },
}
