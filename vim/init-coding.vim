"
" Coding Vim Settings
"
" Settings taken over the years that have considerably helped 
" coding a lot easier, some dependencies on external plugins
" are expected
"

source $VIMHOME/init-minimal.vim

if has('cscope')
  set cscopetag cscopeverbose

  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  cnoreabbrev csa cs add
  cnoreabbrev csf cs find
  cnoreabbrev csk cs kill
  cnoreabbrev csr cs reset
  cnoreabbrev css cs show
  cnoreabbrev csh cs help

  set csto=0
  set cst

  map <leader>sr  :cs find c <C-R>=expand("<cword>")<CR><CR>
  map <leader>ss  :cs find s <C-R>=expand("<cword>")<CR><CR>
  map <leader>sd  :cs find d <C-R>=expand("<cword>")<CR><CR>

  function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
      let path = strpart(db, 0, match(db, "/cscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db . " " . path
      set cscopeverbose
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
    endif
  endfunction
  au BufEnter /* call LoadCscope()
endif

" build tags of your own project with F12
nnoremap <expr> <leader>tg ':!ctags -f '.projectroot#guess().'/tags -R '.projectroot#guess().' <cr><cr>'

" ** YouCompleteMe **
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoTo<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <C-q>      :YcmCompleter GetDoc

nnoremap <F9>       :YcmForceCompileAndDiagnostics<CR>

"let g:ycm_confirm_extra_conf                  = 0
let g:ycm_global_ycm_extra_conf               = '~/.vim/ycm/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_always_populate_location_list       = 1
let g:ycm_server_log_level                    = 'debug'

" ** Syntastic **
function! DetectCheckPatch(file)
  let topdir = fnamemodify(finddir('.git', a:file . ';'), ':h')

  if !filereadable(topdir . '/Kbuild')
    return
  endif

  if executable(topdir . '/scripts/checkpatch.pl')
    let g:syntastic_cpp_checkpatch_exec = fnamemodify(topdir . '/scripts/checkpatch.pl', ':p')
    let b:syntastic_cpp_checkers = ["checkpatch"]
  endif
endfunction

"augroup kernel
  "autocmd BufNewFile,BufReadPost *.c,*.h :call DetectCheckPatch(expand('<afile>:p'))
"augroup END

let g:syntastic_c_check_header           = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
"let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_error_symbol             = 'x'
let g:syntastic_warning_symbol           = '!'

let g:syntastic_mode_map = {
      \ "mode": "active",
      \ "active_filetypes": ["ruby", "php"],
      \ "passive_filetypes": ["java", "c"] }

" ** UltiSnips **
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  "set grepprg=ag\ --vimgrep

  " Replace ack searcher
  let g:ackprg = 'ag --smart-case'
  cnoreabbrev ag Ack

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching  = 0
endif

" quick search with ctrl-shift-K binding
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :Grepper -open -cword -noprompt<cr>
nnoremap <leader>f :Grepper<cr>
nnoremap <leader>fw :Grepper -open -cword -noprompt<cr>
nnoremap <leader>fr :Grepper -open -dir repo,filecwd -cword -noprompt<cr>
nnoremap <leader>fs :Grepper -open -side -dir repo,filecwd -cword -noprompt<cr>

let g:grepper               = {
      \ 'tools':          ['git', 'ag', 'rg'],
      \ 'jump':           1,
      \ 'simple_prompt':  1,
      \ 'quickfix':       1,
      \ 'git':            { 'grepprg': 'git grep --no-color -nI' }
      \ }

""""""""""""""""""""""""""""""
" Auto Completion
""""""""""""""""""""""""""""""
set nocp

" ** OmniCppComplete **
let OmniCpp_NamespaceSearch   = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess        = 1
let OmniCpp_MayCompleteDot    = 1
let OmniCpp_MayCompleteArrow  = 1
let OmniCpp_MayCompleteScope  = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" Operations on changed lines
function! GlobalChangedLines(ex_cmd)
  for hunk in GitGutterGetHunks()
    for lnum in range(hunk[2], hunk[2]+hunk[3]-1)
      let cursor = getcurpos()
      silent! execute lnum.a:ex_cmd
      call setpos('.', cursor)
    endfor
  endfor
endfunction

" editor config
let g:EditorConfig_max_line_indicator = "fill"
" make editorconfig work nice with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

command! -nargs=1 Glines call GlobalChangedLines(<q-args>)

" Remove triling whitespace on edited lines
autocmd BufWritePre * Glines s/\s\+$/

" Finds the Git super-project directory based on the file passed as an argument.
function! g:BMBufferFileLocation(file)
    let filename = 'vim-bookmarks'
    let location = ''
    if isdirectory(fnamemodify(a:file, ":p:h").'/.git')
        " Current work dir is git's work tree
        let location = fnamemodify(a:file, ":p:h").'/.git'
    else
        " Look upwards (at parents) for a directory named '.git'
        let location = finddir('.git', fnamemodify(a:file, ":p:h").'/.;')
    endif
    if len(location) > 0
        return simplify(location.'/.'.filename)
    else
        return simplify(fnamemodify(a:file, ":p:h").'/.'.filename)
    endif
endfunction

""""""""""""""""""""""""""""""
" Vim Diff Setup
""""""""""""""""""""""""""""""
function! IgnoreDiff(pattern)
    let opt = ""
    if &diffopt =~ "icase"
      let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
      let opt = opt . "-b "
    endif
    let cmd = "!diff -a --binary " . opt .
      \ " <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_in .
      \ ") <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_new .
      \ ") > " . v:fname_out
    echo cmd
    silent execute cmd
    redraw!
    return cmd
endfunction
command! IgnoreDiffDiffs set diffexpr=IgnoreDiff('^@@\ .*\|^index\ .*\|^commit\ .*') | diffupdate<CR>

" Custom setup for vimdiff
function! DiffSetup()
  set nofoldenable foldcolumn=0 number
  wincmd b
  set nofoldenable foldcolumn=0 number
  let &columns = &columns * 2
  wincmd =
  winpos 0 0
endfun

if &diff
  autocmd VimEnter * call DiffSetup()
endif

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>

" ** Vim bookmarks **
let g:bookmark_highlight_lines      = 1
let g:bookmark_save_per_working_dir = 1

