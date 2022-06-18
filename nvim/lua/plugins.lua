local M = {}

local packer_bootstrap = false
local prequire = require('utils.common').prequire

local function packer_init()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
  end

  vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
  ]])
end

packer_init()

function M.setup()
  local conf = {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
  }

  local function plugins(use)
    use { 'lewis6991/impatient.nvim' }
    use { 'dstein64/vim-startuptime' }

    use { 'wbthomason/packer.nvim' }

    --
    -- [[ Common Plugins ]]
    --
    -- TODO: check some of these plugins
    use 'tpope/vim-sensible'                    -- Defaults everyone can agree on
    use 'tpope/vim-eunuch'                      -- Unix shell commands
    use 'will133/vim-dirdiff'                   -- Dir diff
    use 'vim-scripts/CursorLineCurrentWindow'   -- Cursor line only for current window

    use {
      'aymericbeaumet/vim-symlink',             -- Handling of symlinks
      requires = { 'moll/vim-bbye' }
    }
    use { 'nvim-lua/popup.nvim' }               -- An implementation of the Popup API from vim in Neovim

    use {                                       -- Highlight trailing white space
      'ntpeters/vim-better-whitespace',
      config = function()
        vim.g.better_whitespace_ctermcolor = "red"
        vim.g.better_whitespace_guicolor = "red"
        vim.g.strip_whitespace_on_save = 1
        vim.g.strip_only_modified_lines = 1
      end
    }

    --
    -- [[ Syntax Plugins ]]
    --

    use {
      'editorconfig/editorconfig-vim',     -- Syntax using .editorconfig files
      config = function()
        vim.g.EditorConfig_max_line_indicator = "fill"
      end
    }
    -- use 'scrooloose/syntastic'              -- Checks syntax

    use {
      'kana/vim-operator-user',
      requires = { 'rhysd/vim-clang-format' },
      config = function()
        vim.cmd[[
          autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
          autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
          autocmd FileType c,cpp,objc map <buffer> = <Plug>(operator-clang-format)
        ]]
      end,
    }

    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    }


    --
    -- [[ Source Code Editor ]]
    --

    use {                                       -- Easily add comments
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }
    use {                                       -- Brackets autopair plugin
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end
    }


    --
    -- [[ Source Code/Text Browsing ]]
    --
    use { 'tpope/vim-unimpaired' }              -- Quick navigation using []
    use { 'MattesGroeger/vim-bookmarks' }       -- set vim bookmarks
    -- use {                                       -- search tool
    --   'mhinz/vim-grepper',
    --   -- cmd = {'Grepper', '<plug>(GrepperOperator)'},
    -- }

    use {                                       -- Mark/highlight words to analyze faster
      'inkarkat/vim-mark',
      requires = { 'inkarkat/vim-ingo-library' }
    }

    -- use {                                       -- Easy motion with mappings
    --   'easymotion/vim-easymotion',
    --   event = "BufRead",
    --   config = function()
    --     vim.g.EasyMotion_smartcase = 1
    --   end
    -- }
    use {                                       -- Easy motion like plugin for nvim
      'phaazon/hop.nvim',
      branch = 'v1', -- optional but strongly recommended
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require('hop').setup()
      end
    }

    use { 'wellle/targets.vim' }                -- Quick shortcuts


    --
    -- [[ Source Control Integration ]]
    --
    use { 'tpope/vim-fugitive' }                                       -- The git plugin

    -- use {                                       -- show signs of lines add/deleted
    --   'airblade/vim-gitgutter',
    --   event = "BufRead"
    -- }

    use {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns").setup()
      end,
    }

    -- TODO: check these plugins
    use 'dbakker/vim-projectroot'               -- Easily jump to root of project


    --
    -- [[ Terminal Integration Plugins ]]
    --
    use 'wsdjeg/vim-fetch'                      -- Go to line when opening with 'vim file:line'
    use 'christoomey/vim-tmux-navigator'        -- Tmux integration
    use {                                       -- Split resizing/navigation
      'mrjones2014/smart-splits.nvim',
      config = function()
        local splits = require('smart-splits')
        vim.keymap.set('n', '<A-h>', splits.resize_left)
        vim.keymap.set('n', '<A-j>', splits.resize_down)
        vim.keymap.set('n', '<A-k>', splits.resize_up)
        vim.keymap.set('n', '<A-l>', splits.resize_right)
      end
    }
    use { 'ojroques/vim-oscyank',               -- Yank text to terminal via osc52
      config = function()
        vim.cmd [[autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif]]
      end
    }


    --
    -- [[ Theme ]]
    --
    use { 'mhinz/vim-startify' }                -- start screen
    use { 'DanilaMihailov/beacon.nvim' }        -- cursor jump
    use { 'Mofiqul/vscode.nvim',                -- color scheme
      config = function()
        vim.g.vscode_style = 'dark'
        vim.g.vscode_italic_comment = true
        vim.cmd [[colorscheme vscode]]
      end
    }

    use {
      'kdheepak/tabline.nvim',
      requires = {
        { 'nvim-lualine/lualine.nvim' },
        { 'kyazdani42/nvim-web-devicons' }
      },
      config = function()
        require('config.tabline').setup()
      end
    }


    --
    -- [[ Language Completion (lsp) ]]
    --
    use {
      'neovim/nvim-lspconfig',                  -- Collection of configurations for the built-in LSP client
      requires = {
        'nvim-lua/plenary.nvim',
        'williamboman/nvim-lsp-installer',
        'jose-elias-alvarez/null-ls.nvim',
      },
      config = function()
        require('config.lspconfig').setup()
      end
    }

    use {
      'kosayoda/nvim-lightbulb',
      config = function()
        require('nvim-lightbulb').setup({
          ignore = {'null-ls'},
          autocmd = { enabled = true },
        })
      end
    }

    use {                                      -- Code Action menu for lsp
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    }

    -- Treesitter configurations and abstraction layer for Neovim
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('config.treesitter').setup()
      end
    }
    use {
      'romgrk/nvim-treesitter-context',
      requires = {'nvim-treesitter/nvim-treesitter'},
      config = function()
        require('treesitter-context').setup()
      end
    }

    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
      },
      config = function()
        require('config.cmp').setup()
      end
    }

    -- For vsnip as snippet manager for LSP completion
    -- use { 'hrsh7th/cmp-vsnip', requires = { 'hrsh7th/vim-vsnip' }}

    use {
      'saadparwaiz1/cmp_luasnip',
      requires = { 'L3MON4D3/LuaSnip' }
    }

    use { 'onsails/lspkind-nvim' }
    use {
      'rafamadriz/friendly-snippets',           -- common snippets for faster development
      config = function ()
        local luasnip = require('utils.common').prequire('luasnip')
        if luasnip then
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      end
    }

    use { 'ray-x/lsp_signature.nvim',           -- function signature for some lsp
      config = function()
        require('lsp_signature').setup()
      end
    }

    use {
      'j-hui/fidget.nvim',                      -- nvim-lsp progress. Eye candy for the impatient
      event = "BufReadPre",
      config = function()
        require('fidget').setup()
      end
    }

    --
    -- [[ IDE ]]
    --
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      },
      config = function()
        require('config.telescope').setup()
      end
    }

    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
        }
      end
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons',         -- optional, for file icon
      },
      config = function()
        require('config.nvim-tree').setup()
      end
    }

    use {                                       -- Display possible key bindings
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }

    -- Legendary
    use {
      "mrjones2014/legendary.nvim",
      keys = { [[<C-p>]] },
      config = function()
        require("config.legendary").setup()
      end,
      requires = { "stevearc/dressing.nvim" },
    }

    if packer_bootstrap then
      print "Setting up Neovim. Restart required after installation!"
      require("packer").sync()
    end
  end

  prequire('impatient')
  require("packer").init(conf)
  require("packer").startup(plugins)
end

return M
