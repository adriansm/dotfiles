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
map <Leader>tt :TagbarToggle<CR>

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

function! LoadPluginOptions()
  "
  " CtrlP options
  "
  if exists(":CtrlPBuffer")
    let g:ctrlp_custom_ignore = {
          \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
          \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
          \}
    let g:ctrlp_working_path_mode = 'ra'

    " Allow use of leader as well as CtrlP
    "nmap <leader>p :CtrlP<cr>

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
  endif


  "
  " Denite options
  "
  if exists(":Denite")
    "   ;         - Browser currently open buffers
    "   <leader>o - Browse list of files in current directory
    "   <leader>p - Browse list of files in project directory
    nmap ; :Denite buffer -split=floating<CR>
    nmap <leader>o :Denite file/rec -split=floating<CR>
    nmap <leader>p :DeniteProjectDir file/rec -split=floating<CR>

    if executable('ag')
      " use ag to list current directory files
      call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--ignore', '.git', '-g', ''])

      " use ag instead of grep
      call denite#custom#var('grep', 'command', ['ag'])

      " Custom options for ag
      call denite#custom#var('grep', 'default_opts', ['--vimgrep', '-i', '-S', '-f'])
      call denite#custom#var('grep', 'recursive_opts', [])
      call denite#custom#var('grep', 'pattern_opt', [])
      call denite#custom#var('grep', 'separator', ['--'])
      call denite#custom#var('grep', 'final_opts', [])
    endif

    " Change mappings.
    call denite#custom#map(
          \ 'insert',
          \ '<C-j>',
          \ '<denite:move_to_next_line>',
          \ 'noremap'
          \)
    call denite#custom#map(
          \ 'insert',
          \ '<C-k>',
          \ '<denite:move_to_previous_line>',
          \ 'noremap'
          \)

    " Custom options for Denite
    "   auto_resize             - Auto resize the Denite window height automatically.
    "   prompt                  - Customize denite prompt
    "   direction               - Specify Denite window direction as directly below current pane
    "   winminheight            - Specify min height for Denite window
    "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
    "   prompt_highlight        - Specify color of prompt
    "   highlight_matched_char  - Matched characters highlight
    "   highlight_matched_range - matched range highlight
    call denite#custom#option('default', {
          \ 'auto_resize': 1,
          \ 'prompt': 'λ:',
          \ 'direction': 'rightbelow',
          \ 'winminheight': '10',
          \ })

    " Remove date from buffer list
    call denite#custom#var('buffer', 'date_format', '')
  endif
endfunction

au VimEnter * call LoadPluginOptions()


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
