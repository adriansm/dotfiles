local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

function load_config(plugin)
  require('plugins.'..plugin)
end

--
-- Plug-ins Start from here
--
return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  --
  -- [[ Common Plugins ]]
  --
  -- TODO: check some of these plugins
--  use 'tpope/vim-dispatch'                    -- dispatch make async
  use 'tpope/vim-sensible'                    -- Defaults everyone can agree on
  use 'tpope/vim-eunuch'                      -- Unix shell commands
  use 'will133/vim-dirdiff'                   -- Dir diff
  use 'vim-scripts/CursorLineCurrentWindow'   -- Cursor line only for current window

  use {'aymericbeaumet/vim-symlink',          -- Handling of symlinks
    requires = 'moll/vim-bbye' }

  --
  -- [[ Syntax Plugins ]]
  --

  use 'editorconfig/editorconfig-vim'     -- Syntax using .editorconfig files
  use 'scrooloose/syntastic'              -- Checks syntax

  -- TODO: enable clang formatter
  -- use 'kana/vim-operator-user'
  -- use 'rhysd/vim-clang-format'


  --
  -- [[ Source Code Editor ]]
  --

  -- Easily add comments
  use { 'numToStr/Comment.nvim', config = function()
	  require('Comment').setup()
  end
  }


  --
  -- [[ Source Code/Text Browsing ]]
  --
  use 'tpope/vim-unimpaired'              -- Quick navigation using []
  use 'MattesGroeger/vim-bookmarks'       -- set vim bookmarks

  -- TODO: check these plugins
  use 'mileszs/ack.vim'                   -- search tool from vim
  use 'mhinz/vim-grepper'                 -- search tool

  use 'inkarkat/vim-ingo-library'
  use 'inkarkat/vim-mark'                 -- Mark/highlight words to analyze faster

  use 'easymotion/vim-easymotion'         -- Easy motion with mappings
  use 'wellle/targets.vim'                -- Quick shortcuts
  use { 'windwp/nvim-autopairs',          -- Brackets autopair plugin
    config = load_config('nvim-autopairs')
  }


  --
  -- [[ Source Control Integration ]]
  --
  use 'tpope/vim-fugitive'                -- The git plugin
  use 'airblade/vim-gitgutter'            -- show signs of lines add/deleted

  -- TODO: check these plugins
  use 'dbakker/vim-projectroot'           -- Easily jump to root of project


  --
  -- [[ Terminal Integration Plugins ]]
  --
  use 'bogado/file-line'                  -- Go to line when opening with 'vim file:line'
  use 'christoomey/vim-tmux-navigator'    -- Tmux integration
  use { 'ojroques/vim-oscyank',           -- Yank text to termina via osc52
    config = function()
      vim.cmd [[autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif]]
    end
  }


  --
  -- [[ Theme ]]
  --
  use { 'mhinz/vim-startify' }                       -- start screen
  use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump
  use { 'Mofiqul/vscode.nvim', config = function()   -- color scheme
    vim.g.vscode_style = 'dark'
    vim.g.vscode_italic_comment = true
    vim.cmd [[colorscheme vscode]]
  end}

  use {
    'kdheepak/tabline.nvim',
    requires = {
      { 'nvim-lualine/lualine.nvim' },
      { 'kyazdani42/nvim-web-devicons' }
    },
    config = load_config('tabline'),
  }

  --
  -- [[ Language Completion (lsp) ]]
  --
  use {
    'neovim/nvim-lspconfig',
    requires = {'williamboman/nvim-lsp-installer'},
    config = load_config('lspconfig'),
  }

  -- A light-weight LSP plugin based on Neovim built-in LSP with highly a performant UI
  use {
    'tami5/lspsaga.nvim',
    config = load_config('lspsaga'),
  }

  -- Treesitter configurations and abstraction layer for Neovim
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = load_config('treesitter'),
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
    },
    config = load_config('cmp')
  }

  -- For vsnip users.
  use { 'hrsh7th/cmp-vsnip', requires = { use 'hrsh7th/vim-vsnip', opt = true }}

  use 'onsails/lspkind-nvim'


  --
  -- [[ IDE ]]
  --
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() require('telescope').setup() end
  }

  -- use 'scrooloose/nerdtree'
  -- use 'Xuyuanp/nerdtree-git-plugin'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = load_config('nvim-tree')
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
      require('packer').sync()
  end
end)

