local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

--
-- Plug-ins Start from here
--
return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  --
  -- Common Plugins
  --
  -- TODO: check some of these plugins
--  use 'tpope/vim-dispatch'                    -- dispatch make async
  use 'tpope/vim-sensible'                    -- Defaults everyone can agree on
  use 'tpope/vim-eunuch'                      -- Unix shell commands
  use 'will133/vim-dirdiff'                   -- Dir diff
  use 'vim-scripts/CursorLineCurrentWindow'   -- Cursor line only for current window

  --
  -- Color Theme
  --
  use {'Mofiqul/vscode.nvim', config = function()
    vim.g.vscode_style = 'dark'
    vim.g.vscode_italic_comment = true
    vim.cmd [[colorscheme vscode]]
  end}

  --
  -- Syntax Plugins
  --

  use 'editorconfig/editorconfig-vim'     -- Syntax using .editorconfig files
  use 'scrooloose/syntastic'              -- Checks syntax

  -- TODO: enable clang formatter
  -- use 'kana/vim-operator-user'
  -- use 'rhysd/vim-clang-format'


  --
  -- Source Code Editor
  --

  -- Easily add comments
  use { 'numToStr/Comment.nvim', config = function()
	  require('Comment').setup()
  end
  }


  --
  -- Source Code/Text Browsing
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


  --
  -- Source Control Integration
  --
  use 'tpope/vim-fugitive'                -- The git plugin
  use 'airblade/vim-gitgutter'            -- show signs of lines add/deleted

  -- TODO: check these plugins
  use 'dbakker/vim-projectroot'           -- Easily jump to root of project


  --
  -- Terminal Integration Plugins
  --
  use 'bogado/file-line'                  -- Go to line when opening with 'vim file:line'
  use 'christoomey/vim-tmux-navigator'    -- Tmux integration
  use 'ojroques/vim-oscyank'              -- Yank text to termina via osc52


  --
  -- Status bar plugin
  --
  use {
    'kdheepak/tabline.nvim',
    requires = {
      { 'nvim-lualine/lualine.nvim' },
      { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    config = function()
      require('tabline').setup {
        -- Defaults configuration options
        enable = true,
        options = {
          -- If lualine is installed tabline will use separators configured in lualine by default.
          -- These options can be used to override those settings.
          section_separators = {'', ''},
          component_separators = {'', ''},
          max_bufferline_percent = 80, -- set to nil by default, and it uses vim.o.columns * 2/3
          show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
          show_devicons = true, -- this shows devicons in buffer section
          show_bufnr = false, -- this appends [bufnr] to buffer section,
          show_filename_only = false, -- shows base filename only instead of relative path in filename
          modified_icon = "+ ", -- change the default modified icon
          modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
        }
      }

      require('lualine').setup {
        extensions = {
          'nerdtree'
        },
        options = {
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          theme = 'vscode'
        },
        tabline = {
          lualine_c = { require('tabline').tabline_buffers },
          lualine_x = { require('tabline').tabline_tabs }
        }
      }
      vim.cmd[[
        set guioptions-=e                       " Use showtabline in gui vim
        set sessionoptions+=tabpages,globals    " store tabpages and globals in session
      ]]
    end
  }

  --
  -- Language Completion (lsp)
  --
  use { 
    'neovim/nvim-lspconfig', 
    'williamboman/nvim-lsp-installer',
  }

  -- A light-weight LSP plugin based on Neovim built-in LSP with highly a performant UI
  use 'tami5/lspsaga.nvim'

  -- Treesitter configurations and abstraction layer for Neovim
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'onsails/lspkind-nvim'


  --
  -- IDE
  --
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('telescope').setup()
    end
  }

  use 'scrooloose/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
      require('packer').sync()
  end
end)

