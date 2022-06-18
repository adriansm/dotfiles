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
Plug 'scrooloose/syntastic'             " Checks syntax

Plug 'sheerun/vim-polyglot'             " Language Pack
Plug 'nickhutchinson/vim-cmake-syntax', { 'for': 'cmake' }
Plug 'elzr/vim-json',                   { 'for': 'json' }
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
Plug 'tomtom/tcomment_vim'


"
" Code Browsing
"
Plug 'tpope/vim-unimpaired'             " Quick navigation using []
Plug 'haya14busa/incsearch.vim'         " Highlight incremental searches
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-easymotion.vim'
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
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/CursorLineCurrentWindow' " Cursor line only for current window

"
" Local plugins
"
set rtp^=$VIMHOME/custom/adrian.vim


"""" NOTE: remaining plugins shouldn't be required if not running nvim
"""" for example as a an extension directly
if !exists('g:vscode')
  "
  " Status bar plugins
  "
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'


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
    Plug 'jackguo380/vim-lsp-cxx-highlight'
  endif

  "
  " Ide-like features
  "

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
