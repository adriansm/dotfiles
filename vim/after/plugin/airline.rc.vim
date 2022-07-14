if !exists('g:loaded_airline') | finish | endif

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

" truncate all path sections but the last one
" e.g. a branch foo/bar/baz becomes f/b/baz
let g:airline#extensions#branch#format = 2
let g:airline#extensions#bookmark#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_nr_type = 1

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

" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]


let g:airline#extensions#coc#enabled = 0
let airline#extensions#coc#error_symbol = 'Error:'
let airline#extensions#coc#warning_symbol = 'Warning:'
let g:airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let g:airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

"let g:tmuxline_powerline_separators = 0

"let g:tmuxline_separators = {
    "\ 'left' : '',
    "\ 'left_alt': '>',
    "\ 'right' : '',
    "\ 'right_alt' : '<',
    "\ 'space' : ' '}

let g:airline#extensions#tmuxline#snapshot_file = "~/.config/tmux/design.conf"

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

