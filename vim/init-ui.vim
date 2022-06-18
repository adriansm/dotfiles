"
" UI Vim Settings
"
" Settings that affect UI, color scheme of editor and other related settings
"

""""""""""""""""""""""""""""""
" Design Changes
""""""""""""""""""""""""""""""

if $TERM =~ "256color"
  set t_Co=256                         " Enable 256 colors
  set t_AB=^[[48;5;%dm
  set t_AF=^[[38;5;%dm
endif
if (($COLORTERM == 'truecolor') || ($COLOR_TERM == '24bit') || ($TERM == 'screen-256color'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1

    if (has("termguicolors"))
        " set Vim-specific sequences for RGB colors
        let t_8f="\<Esc>[38;2;%lu;%lu;%lum"
        let t_8b="\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
    endif
endif

"" Format the statusline
"set statusline=\ %<%F\ %h%m%r%=%{fugitive#statusline()}\ %-14.(%l/%L:%c%V%)

"" Syntastic plugin warnings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

set background=dark
let g:solarized_termcolors=256
let g:rehash256=1
colorscheme adrian

" show line numbers
set number relativenumber

" toggle relative numbers for active buffers
augroup numbertoggle
  autocmd!
  autocmd WinEnter,BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

highlight LineNr ctermfg=darkgrey guifg=#050505

" Set cursor line only on selected window
autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
setlocal cursorline

" enable mouse support
set mouse=a
if !has("nvim")
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  end
end

" copy the current text selection to the system clipboard
if has('gui_running') || has('nvim') && exists('$DISPLAY')
  noremap <Leader>y "+y
else
  " copy to attached terminal using the yank(1) script:
  " https://github.com/sunaku/home/blob/master/bin/yank
  noremap <silent> <Leader>y y:call system('yank > /dev/tty', @0)<Return>
endif

" Easily split windows
nmap <C-W>\| :vsplit<CR>
nmap <C-W>- :split<CR>

" ** airline/tmux line **
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#ycm#enabled = 1

let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ }
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
"%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v
let g:airline_section_z = "%4l/%L%{g:airline_symbols.maxlinenr} :%3v"

let g:airline#extensions#whitespace#mixed_indent_algo = 2

"let g:tmuxline_powerline_separators = 0

"let g:tmuxline_separators = {
    "\ 'left' : '',
    "\ 'left_alt': '>',
    "\ 'right' : '',
    "\ 'right_alt' : '<',
    "\ 'space' : ' '}

let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux.design.conf"

" override backround for autocomplete popup on angr theme
"hi Pmenu      guibg=#3a3a3a ctermbg=237
