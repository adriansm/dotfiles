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

Plug 'godlygeek/tabular'                " Tabular helper (required by vim-markdown)
"Plug 'scrooloose/syntastic'             " Checks syntax

Plug 'sheerun/vim-polyglot'             " Language Pack
Plug 'nickhutchinson/vim-cmake-syntax', { 'for': 'cmake' }
Plug 'elzr/vim-json',                   { 'for': 'json' }
Plug 'naseer/logcat',                   { 'for': 'logcat' }
Plug 'plasticboy/vim-markdown',         { 'for': 'markdown' }

Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-clang-format'

"
" Source Code Editor
"

Plug 'scrooloose/nerdcommenter'         " Easily adds comments
" Plug 'tpope/vim-commentary'             " Easily add comments


"
" Code Browsing
"
Plug 'tpope/vim-unimpaired'             " Quick navigation using []
Plug 'haya14busa/incsearch.vim'
Plug 'easymotion/vim-easymotion'
Plug 'wellle/targets.vim'               " Quick shortcuts


"
" Status bar plugins
"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'


"
" Tmux integration
"
Plug 'christoomey/vim-tmux-navigator'


"
" Themes
"
Plug 'sheerun/vim-wombat-scheme'
"Plug 'jacoborus/tender.vim'
"Plug 'keith/parsec.vim'
"Plug 'joshdick/onedark.vim'

Plug 'lilydjwg/colorizer'


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
" Source control integration
"
Plug 'tpope/vim-fugitive'           " The git plugin
Plug 'airblade/vim-gitgutter'       " show signs of lines add/deleted
Plug 'dbakker/vim-projectroot'      " Easily jump to root of project

Plug 'mileszs/ack.vim'              " search tool from vim
Plug 'mhinz/vim-grepper',           { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'bogado/file-line'             " Go to line when opening with 'vim file:line'
Plug 'MattesGroeger/vim-bookmarks'  " set vim bookmarks


"
" Language Completion
"

if has('python')
  Plug 'SirVer/ultisnips'
  if get(g:, 'lang_completion', '') == 'ycm'
    " Code Completion
    Plug 'Valloric/YouCompleteMe',    {
          \ 'do': './install.py --clang-completer --java-completer'
          \ }
    "Plug 'rdnetto/YCM-Generator',      { 'branch': 'stable'}
  endif
endif

if get(g:, 'lang_completion', '') == 'lps'
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
endif


"
" Others
"

Plug 'Valloric/ListToggle'          " Quickly get locationlist and quickfix window
Plug 'tpope/vim-dispatch'           " dispatch make async
Plug 'tpope/vim-sensible'           " Defaults everyone can agree on
Plug 'tpope/vim-eunuch'             " Unix shell commands
Plug 'will133/vim-dirdiff'          " Dir diff
Plug 'vim-scripts/CursorLineCurrentWindow' " Cursor line only for current window

if has('python3')
Plug 'Shougo/denite.nvim', {'tag': '*' }
endif

Plug 'ryanoasis/vim-devicons'

"
" Local plugins
"
set rtp^=$VIMHOME/custom/adrian.vim
