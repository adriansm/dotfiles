"
" Plugin Loading
"
" List of plugins required by different scripts.
"
" NOTE: plug#begin must be called before including this
"

"
" Syntax Plugins
"

Plug 'editorconfig/editorconfig-vim'    " Syntax using .editorconfig files

" Plug 'godlygeek/tabular'                " Tabular helper (required by vim-markdown)
Plug 'scrooloose/syntastic'             " Checks syntax

Plug 'sheerun/vim-polyglot'             " Language Pack
" Plug 'nickhutchinson/vim-cmake-syntax', { 'for': 'cmake' }
" Plug 'elzr/vim-json',                   { 'for': 'json' }
Plug 'naseer/logcat',                   { 'for': 'logcat' }
"Plug 'plasticboy/vim-markdown',         { 'for': 'markdown' }

if get(g:, "enable_clang_format", 1)
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-clang-format'
endif

"
" Source Code Editor
"

" Plug 'scrooloose/nerdcommenter'         " Easily adds comments
" Plug 'tpope/vim-commentary'             " Easily add comments
if has('nvim')
  Plug 'numToStr/Comment.nvim'
else
  Plug 'tomtom/tcomment_vim'
endif


"
" Code Browsing
"
Plug 'tpope/vim-unimpaired'             " Quick navigation using []
Plug 'easymotion/vim-easymotion'
" Plug 'haya14busa/incsearch.vim'         " Highlight incremental searches
" Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'wellle/targets.vim'               " Quick shortcuts


"
" Source Control Integration
"
Plug 'tpope/vim-fugitive'           " The git plugin
Plug 'airblade/vim-gitgutter'       " show signs of lines add/deleted
Plug 'dbakker/vim-projectroot'      " Easily jump to root of project


"
" Source Code Navigation
"
Plug 'mileszs/ack.vim'              " search tool from vim
Plug 'mhinz/vim-grepper',           { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'MattesGroeger/vim-bookmarks'  " set vim bookmarks
Plug 'bogado/file-line'             " Go to line when opening with 'vim file:line'

Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'            " Mark/highlight words

"
" Tmux integration
"
Plug 'christoomey/vim-tmux-navigator'


"
" Others
"

" Yank text to terminal via osc52
Plug 'ojroques/vim-oscyank',      { 'branch': 'main'}
Plug 'Valloric/ListToggle'          " Quickly get locationlist and quickfix window
Plug 'tpope/vim-dispatch'           " dispatch make async
Plug 'tpope/vim-sensible'           " Defaults everyone can agree on
Plug 'tpope/vim-eunuch'             " Unix shell commands
Plug 'will133/vim-dirdiff'          " Dir diff
Plug 'vim-scripts/CursorLineCurrentWindow' " Cursor line only for current window


"""" NOTE: remaining plugins shouldn't be required if not running nvim
"""" for example as a an extension directly
if exists('g:vscode')
  finish
endif

"
" Status bar plugins
"
if has('nvim')
  Plug 'nvim-lualine/lualine.nvim'
  " If you want to have icons in your statusline choose one of these
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kdheepak/tabline.nvim'
else
  Plug 'ryanoasis/vim-devicons'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'
endif


"
" Themes
"
Plug 'sheerun/vim-wombat-scheme'
"Plug 'jacoborus/tender.vim'
"Plug 'keith/parsec.vim'
"Plug 'joshdick/onedark.vim'

Plug 'lilydjwg/colorizer'
Plug 'Mofiqul/vscode.nvim'


"
" File Browsing
"
"Plug 'ctrlpvim/ctrlp.vim'           " Fast file switching
Plug 'junegunn/fzf',                {
      \ 'dir': '~/.fzf',
      \ 'do': './install --key-bindings --completion'
      \ }
Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree',         { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle' }
Plug 'tpope/vim-vinegar'            " Play nice with netrw


"
" Language Completion
"

if has('python')
  " Plug 'SirVer/ultisnips'
  if get(g:, 'lang_completion', '') == 'ycm'
    " Code Completion
    Plug 'Valloric/YouCompleteMe',    {
          \ 'do': './install.py --clang-completer --java-completer'
          \ }
    "Plug 'rdnetto/YCM-Generator',      { 'branch': 'stable'}
  endif
endif

if get(g:, 'lang_completion', '') == 'lsp'
  Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }

  if has('python3')
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
  endif
endif

if get(g:, 'lang_completion', '') == 'coc'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif

if get(g:, 'lang_completion', '') == 'nvim' && has('nvim')
  " A collection of configurations for Neovim’s built-in LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'

  " A light-weight LSP plugin based on Neovim built-in LSP with highly a performant UI
  Plug 'tami5/lspsaga.nvim'

  " Treesitter configurations and abstraction layer for Neovim
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " Plug 'nvim-lua/completion-nvim'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " For vsnip users.
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  Plug 'onsails/lspkind-nvim'
endif

"
" Ide-like features
"

if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
else
  if has('python3')
    if has('nvim')
      Plug 'Shougo/denite.nvim', {'tag': '*', 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/denite.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
  endif
endif
