"
" IDE Vim Settings
"
" Settings that help vim behave more like an IDE, but may be provided when
" embedded within external IDEs (ex. Oni)
"


"
" External Tag bars
"
noremap <C-e> :NERDTreeToggle<CR>
map <Leader>t :TagbarToggle<CR>


"
" CtrlP options
"
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
  \}
let g:ctrlp_working_path_mode = 'ra'

" Allow use of leader as well as CtrlP
nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching  = 1
endif


"
" VIM File Explorer
"
let g:explVertical     = 1
let g:explWinSize      = 35
let g:explSplitLeft    = 1
let g:explSplitBelow   = 1
let g:explHideFiles    = '^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'
let g:explDetailedHelp = 0


"
" Command T (deprecated)
"
let g:CommandTFileScanner = 'git'
let g:CommandTTraverseSCM = 'file'
let g:CommandTMaxFiles    = 60000


"
" Minibuffer (deprecated)
"
let g:miniBufExplModSelTarget       = 1
let g:miniBufExplorerMoreThanOne    = 2
let g:miniBufExplUseSingleClick     = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:bufExplorerSortBy             = "name"
