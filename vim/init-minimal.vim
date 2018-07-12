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

" ** User Interface **
set history=50
set wildmode=list:longest,full

" ** Text Formatting **
set nowrap              " Do not wrap words (view)
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set wildmenu            " enhanced command completion
set visualbell          " use visual bell instead of beeping
set list listchars=tab:→\ ,

set shiftwidth=4
set tabstop=4
set shiftround
set expandtab
set copyindent

set formatoptions-=t

augroup filetype
  autocmd BufNewFile,BufRead *.dts,*.dtsi           set filetype=dts
  autocmd BufNewFile,BufRead *.cmake,CMakeLists.txt set filetype=cmake
  autocmd BufNewFile,BufRead */.Postponed/*         set filetype=mail
  autocmd BufNewFile,BufRead *.txt                  set filetype=human
  autocmd BufNewFile,BufRead *.ctp                  set filetype=php
  autocmd BufNewFile,BufRead *.aidl,*.hal           set filetype=java
  autocmd BufNewFile,BufRead CMakeLists.txt,*.cmake set filetype=cmake
  autocmd BufNewFile,BufRead *.cmm                  set filetype=practice
augroup END

autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell textwidth=70

autocmd FileType mail,human set formatoptions+=t textwidth=80
"autocmd FileType make      set noexpandtab shiftwidth=8
autocmd FileType perl,css   set smartindent
autocmd FileType html       set formatoptions+=tl
autocmd FileType html,css   set noexpandtab tabstop=4
autocmd FileType practice   set noexpandtab tabstop=8 shiftwidth=8

" ** Search & Replace **
set gdefault
set incsearch           " Incremental search
set hlsearch            " Highlight search match
set ignorecase          " Do case insensitive matching
set smartcase           " do not ignore if search pattern has CAPS

" ** Keystrokes -- Moving around **
set whichwrap=h,l,~,[,]

" backups
set nobackup            " do not write backup files
set noswapfile          " do not write .swp files

" ** MISC **
"Remove the Windows ^M
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

cmap w!! w !sudo tee % >/dev/null

" Delete buffer without closing window
nmap <Leader>bd :b#<bar>bd#<CR>

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

