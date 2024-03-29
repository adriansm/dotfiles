"
" UI Vim Settings
"
" Settings that affect UI, color scheme of editor and other related settings
"


"
" Terminal Settings
"
let s:enable_true_colors=0
if $TMUX == "" && ($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
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

let g:airline_theme='adrian'
colorscheme adrian


" override backround for autocomplete popup on angr theme
"hi Pmenu      guibg=#3a3a3a ctermbg=237

"
" Navigation
"

" toggle relative numbers for active buffers
"augroup numbertoggle
  "autocmd!
  "autocmd WinEnter,BufEnter,FocusGained,InsertLeave * set relativenumber
  "autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

"
" Vim Devicons
"
let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 0
