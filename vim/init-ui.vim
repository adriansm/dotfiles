"
" UI Vim Settings
"
" Settings that affect UI, color scheme of editor and other related settings
"


"
" Terminal Settings
"
let s:enable_true_colors=0
if has('nvim') && ($TERM =~ '256color' || $COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  " neovim has true color approximation even if terminal doesn't support it
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let s:enable_true_colors=1
elseif $TMUX == "" && ($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  let s:enable_true_colors=1
endif

if s:enable_true_colors && has("termguicolors")
  " set Vim-specific sequences for RGB colors
  let t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


"
" Color Settings
"

set background=dark
let g:solarized_termcolors=256
let g:rehash256=1
colorscheme adrian

highlight LineNr ctermfg=darkgrey guifg=#050505

" override backround for autocomplete popup on angr theme
"hi Pmenu      guibg=#3a3a3a ctermbg=237

"
" Navigation
"

" toggle relative numbers for active buffers
augroup numbertoggle
  autocmd!
  autocmd WinEnter,BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Set cursor line only on selected window
autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
setlocal cursorline


"
" Status bar replacement (Airline/Tmux line)
"

"" Format the statusline
"set statusline=\ %<%F\ %h%m%r%=%{fugitive#statusline()}\ %-14.(%l/%L:%c%V%)

"" Syntastic plugin warnings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

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

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>[ <Plug>AirlineSelectPrevTab
nmap <leader>] <Plug>AirlineSelectNextTab
