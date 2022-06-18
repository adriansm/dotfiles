"
" IDE Vim Settings
"
" Settings that help vim behave more like an IDE
"

noremap <C-e> :NERDTreeToggle<CR>
map <Leader>t :TagbarToggle<CR>

" ** CtrlP options **
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

" ** Command T **
let g:CommandTFileScanner = 'git'
let g:CommandTTraverseSCM = 'file'
let g:CommandTMaxFiles    = 60000

" ** File Explorer **
let g:explVertical     = 1
let g:explWinSize      = 35
let g:explSplitLeft    = 1
let g:explSplitBelow   = 1
let g:explHideFiles    = '^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'
let g:explDetailedHelp = 0

" ** Minibuffer **
let g:miniBufExplModSelTarget       = 1
let g:miniBufExplorerMoreThanOne    = 2
let g:miniBufExplUseSingleClick     = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:bufExplorerSortBy             = "name"

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
