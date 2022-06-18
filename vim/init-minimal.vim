"
" Minimal Vim Settings
" 
" Basic set of settings for Vim that should work in all conditions
" without the need of any external plugins.
"

let s:was_compatible = &compatible
if s:was_compatible
  " We can't do this unconditionally: set nocompatible fires other vim events
  " which we don't want to re-run if you already have nocompatible set.
  set nocompatible
endif


"
" User Interface options
"
set number relativenumber   " show line numbers
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set visualbell          " use visual bell instead of beeping
set hidden              " TextEdit might fail if hidden is not set
set cursorline          " Show cursor line

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
elseif has("signcolumn")
  set signcolumn=yes
endif

"
" Text Formatting
"
set nowrap              " Do not wrap words (view)
set list
" set listchars=tab:→\ ,trail:•,extends:⟩,precedes:⟨
let &listchars="tab:\u2192 ,trail:\u2022,extends:\u27E9,precedes:\u27E8"
" set showbreak=↪\
let &showbreak="\u21aa "

set shiftwidth=4
set tabstop=4
set shiftround
set expandtab
set copyindent
set cinoptions+=(0

set formatoptions-=t
set foldmethod=marker

set encoding=UTF-8


"
" File Types and formatting
"
augroup filetype
  autocmd BufNewFile,BufRead *.dts,*.dtsi           set filetype=dts
  autocmd BufNewFile,BufRead *.cmake,CMakeLists.txt set filetype=cmake
  autocmd BufNewFile,BufRead */.Postponed/*         set filetype=mail
  autocmd BufNewFile,BufRead *.txt                  set filetype=human
  autocmd BufNewFile,BufRead *.ctp                  set filetype=php
  autocmd BufNewFile,BufRead *.aidl,*.hal           set filetype=java
  autocmd BufNewFile,BufRead CMakeLists.txt,*.cmake set filetype=cmake
  autocmd BufNewFile,BufRead *.cmm                  set filetype=practice
  autocmd! BufRead,BufNewFile *.proto               set filetype=proto
  autocmd! BufRead,BufNewFile *.asciipb             set filetype=protobuf
augroup END

autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell textwidth=70

autocmd FileType mail,human set formatoptions+=t textwidth=80
"autocmd FileType make      set noexpandtab shiftwidth=8
autocmd FileType perl,css   set smartindent
autocmd FileType html       set formatoptions+=tl
autocmd FileType html,css   set noexpandtab tabstop=4
autocmd FileType practice   set noexpandtab tabstop=8 shiftwidth=8

"
" Search & Replace
"
set gdefault
set incsearch           " Incremental search
set hlsearch            " Highlight search match
set ignorecase          " Do case insensitive matching
set smartcase           " do not ignore if search pattern has CAPS


"
" Clipboard Management
"
set clipboard=unnamed,unnamedplus

vnoremap <leader>y :OSCYank<CR>
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>


"
" Other options
"
set whichwrap=h,l,~,[,] " wrap around at edges
set nobackup            " do not write backup files
set nowritebackup
set noswapfile          " do not write .swp files

" Automatically re-read file if a change was detected outside of vim
set autoread

set history=50
set wildmode=list:longest,full
"set wildmenu            " enhanced command completion

" enable mouse support
set mouse=a
if !has("nvim")
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  end
end

"
" Plugin independent shortcuts
"
map <Space> <Leader>

" Remove the Windows ^M
noremap <Leader>lf mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Force sudo write
cmap w!! w !sudo tee % >/dev/null

" Delete buffer without closing window
nmap <Leader>bd :b#<bar>bd#<CR>

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Easily split windows
nmap <C-W>\| :vsplit<CR>
nmap <C-W>- :split<CR>

