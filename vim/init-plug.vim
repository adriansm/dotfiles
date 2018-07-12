"
" Plugin Loading
"
" List of plugins required by different scripts.
"
" NOTE: plug#begin must be called before including this
"

"*** Syntax Plugins ***

Plug 'editorconfig/editorconfig-vim'    " Syntax using .editorconfig files

Plug 'godlygeek/tabular'                " Tabular helper (required by vim-markdown)
Plug 'scrooloose/syntastic'             " Checks syntax

Plug 'sheerun/vim-polyglot'             " Language Pack
Plug 'nickhutchinson/vim-cmake-syntax', { 'for': 'cmake' }
Plug 'elzr/vim-json',                   { 'for': 'json' }
Plug 'naseer/logcat',                   { 'for': 'logcat' }
Plug 'plasticboy/vim-markdown',         { 'for': 'markdown' }

"*** Code Editor ***

Plug 'scrooloose/nerdcommenter'         " Easily adds comments
Plug 'tpope/vim-unimpaired'             " Quick navigation using

" Status bar plugins
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'

"*** Themes ***
Plug 'sheerun/vim-wombat-scheme'
"Plug 'jacoborus/tender.vim'
"Plug 'keith/parsec.vim'
"Plug 'joshdick/onedark.vim'

"*** Code Browse ***

Plug 'ctrlpvim/ctrlp.vim'           " Fast file switching
Plug 'junegunn/fzf',                { 'dir': '~/.fzf', 'do': './install --key-bindings --completion' }

Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle' }
Plug 'scrooloose/nerdtree',         { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/ListToggle'

Plug 'tpope/vim-fugitive'           " The git plugin
Plug 'airblade/vim-gitgutter'       " show signs of lines add/deleted
Plug 'dbakker/vim-projectroot'      " Easily jump to root of project

Plug 'mileszs/ack.vim'              " search tool from vim
Plug 'mhinz/vim-grepper',           { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'bogado/file-line'             " Go to line when opening with 'vim file:line'
Plug 'MattesGroeger/vim-bookmarks'  " set vim bookmarks

if has('python')
Plug 'SirVer/ultisnips'
" If enabling google's version need to disable this
if get(g:, 'use_google_ycm', 0) == 0
  " Code Completion
  Plug 'Valloric/YouCompleteMe',    { 'do': './install.py --clang-completer --java-completer' }
endif
"Plug 'rdnetto/YCM-Generator',      { 'branch': 'stable'}
endif

"*** Others ***

Plug 'tpope/vim-dispatch'           " dispatch make async
Plug 'tpope/vim-sensible'           " Defaults everyone can agree on

" Local plugins
set rtp^=$VIMHOME/custom/adrian.vim

