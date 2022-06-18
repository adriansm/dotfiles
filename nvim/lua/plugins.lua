local M = {}

local packer_bootstrap = false

local function packer_init()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
  end
  vim.cmd [[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]]
end

packer_init()

function load_config(plugin)
  require('config.'..plugin)
end

function M.setup()
  local conf = {
    compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
  }

  local function plugins(use)
    use { "lewis6991/impatient.nvim" }

    use { 'wbthomason/packer.nvim' }

    --
    -- [[ Common Plugins ]]
    --
    -- TODO: check some of these plugins
  --  use 'tpope/vim-dispatch'                    -- dispatch make async
    use 'tpope/vim-sensible'                    -- Defaults everyone can agree on
    use 'tpope/vim-eunuch'                      -- Unix shell commands
    use 'will133/vim-dirdiff'                   -- Dir diff
    use 'vim-scripts/CursorLineCurrentWindow'   -- Cursor line only for current window

    use {
      'aymericbeaumet/vim-symlink',             -- Handling of symlinks
      requires = 'moll/vim-bbye'
    }
    use { 'nvim-lua/popup.nvim' }               -- An implementation of the Popup API from vim in Neovim


    --
    -- [[ Syntax Plugins ]]
    --

    use {
      'editorconfig/editorconfig-vim',     -- Syntax using .editorconfig files
      config = function()
        vim.g.EditorConfig_max_line_indicator = "fill"
      end
    }
    use 'scrooloose/syntastic'              -- Checks syntax

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

    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }

    --
    -- [[ Source Code Editor ]]
    --

    -- Easily add comments
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }


    --
    -- [[ Source Code/Text Browsing ]]
    --
    use { 'tpope/vim-unimpaired' }              -- Quick navigation using []
    use { 'MattesGroeger/vim-bookmarks' }       -- set vim bookmarks

    -- TODO: check these plugins
    use { 'mhinz/vim-grepper' }                 -- search tool

    use {                                       -- Mark/highlight words to analyze faster
      'inkarkat/vim-mark',
      requires = { 'inkarkat/vim-ingo-library' }
    }

    use 'easymotion/vim-easymotion'         -- Easy motion with mappings
    use 'wellle/targets.vim'                -- Quick shortcuts
    use { 'windwp/nvim-autopairs',          -- Brackets autopair plugin
      config = load_config('nvim-autopairs')
    }


    --
    -- [[ Source Control Integration ]]
    --
    use { 'tpope/vim-fugitive', event = "BufRead" }      -- The git plugin
    use { 'airblade/vim-gitgutter', event = "BufRead" }  -- show signs of lines add/deleted

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
      'neovim/nvim-lspconfig',                  -- Collection of configurations for the built-in LSP client
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
      },
      config = load_config('cmp')
    }

    -- For vsnip as snippet manager for LSP completion
    -- use { 'hrsh7th/cmp-vsnip', requires = { 'hrsh7th/vim-vsnip' }}

    use {
      'saadparwaiz1/cmp_luasnip',
      requires = { 'L3MON4D3/LuaSnip' }
    }

    use {
      'rafamadriz/friendly-snippets',     -- common snippets for faster development
      config = function ()
        local luasnip = require('common').prequire('luasnip')
        if luasnip then
          require("luasnip.loaders.from_vscode").load()
        end
      end
    }

    use 'onsails/lspkind-nvim'

    use { 'ray-x/lsp_signature.nvim',         -- function signature for some lsp
      config = function()
        require('lsp_signature').setup()
      end
    }

    use {
      'j-hui/fidget.nvim',                -- nvim-lsp progress. Eye candy for the impatient
      config = function()
        require('fidget').setup()
      end
    }

    --
    -- [[ IDE ]]
    --
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function()
        require('telescope').setup()
      end
    }

    -- use {
    --   'mrjones2014/legendary.nvim',
    --   config = load_config("legendary")
    -- }

    -- use 'scrooloose/nerdtree'
    -- use 'Xuyuanp/nerdtree-git-plugin'
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = load_config('nvim-tree')
    }

    if packer_bootstrap then
      print "Setting up Neovim. Restart required after installation!"
      require("packer").sync()
    end
  end

  pcall(require, "impatient")
  pcall(require, "packer_compiled")
  require("packer").init(conf)
  require("packer").startup(plugins)
end

return M
