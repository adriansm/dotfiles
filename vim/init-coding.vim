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
if get(g:, 'lang_completion', '') == 'ycm'
  nnoremap <silent>gs :YcmCompleter GoToDeclaration<CR>
  nnoremap <silent>gd :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>gg :YcmCompleter GoTo<CR>
  nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
  nnoremap <silent>gh :YcmCompleter GetDoc<CR>

  nnoremap <F9>       :YcmForceCompileAndDiagnostics<CR>

  let g:ycm_confirm_extra_conf                        = 0
  let g:ycm_global_ycm_extra_conf                      = '~/.vim/ycm/ycm_extra_conf.py'
  let g:ycm_collect_identifiers_from_tags_files        = 0
  let g:ycm_always_populate_location_list              = 1
  "let g:ycm_autoclose_preview_window_after_completion  = 1
  let g:ycm_autoclose_preview_window_after_insertion   = 1
  let g:ycm_min_num_of_chars_for_completion            = 4
  let g:ycm_collect_identifiers_from_tags_files        = 1
elseif get(g:, 'lang_completion', '') == 'lps'
  "let g:LanguageClient_serverCommands = {
  "    \ 'cpp': ['/usr/local/google/home/salidoa/workspace/tools/llvm-6.0.1.src/build/bin/clangd'],
  "    \ 'c': ['/usr/local/google/home/salidoa/workspace/tools/llvm-6.0.1.src/build/bin/clangd']
  "    \ }
  "let g:LanguageClient_serverCommands = {
  "    \ 'cpp': ['clangd'],
  "    \ 'c': ['clangd'],
  "    \ 'vim': ['vim']
  "    \ }
  let g:LanguageClient_serverCommands = {
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
    \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
    \ }

  let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
  let g:LanguageClient_settingsPath = expand($VIMHOME.'/settings.json')
  "set completefunc=LanguageClient#complete
  "set formatexpr=LanguageClient_textDocument_rangeFormatting()

  nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
  nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
  nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  nnoremap <F5> :call LanguageClient_contextMenu()<CR>

  "augroup LanguageClient_config
  "  au!
  "  au BufEnter * let b:Plugin_LanguageClient_started = 0
  "  au User LanguageClientStarted setl signcolumn=yes
  "  au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
  "  au User LanguageClientStopped setl signcolumn=auto
  "  au User LanguageClientStopped let b:Plugin_LanguageClient_stopped = 0
  "  au CursorMoved * if b:Plugin_LanguageClient_started | call LanguageClient_textDocument_hover() | endif
  "augroup END

  let g:LanguageClient_loggingLevel = 'INFO'
  let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
  let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

  let g:deoplete#enable_at_startup = 1
  "if exists('*deoplete#custom#option')
    call deoplete#custom#option({
          \ 'auto_complete_delay': 200,
          \ 'smart_case': v:true,
          \ 'complete_method': 'complete',
          \ 'ignore_sources': {'_': ['buffer', 'around']}
          \ })
    call deoplete#custom#source('LanguageClient',
              \ 'min_pattern_length',
              \ 2)
    " let g:deoplete#disable_auto_complete = 1
    "autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    "" deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<S-tab>"
    inoremap <expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>"
  "endif
endif


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
  set grepprg=ag\ -f\ --nogroup\ --nocolor
  "set grepprg=ag\ --vimgrep

  " Replace ack searcher
  let g:ackprg = 'ag --smart-case'
  cnoreabbrev ag Ack

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching  = 1
endif

" quick search with ctrl-shift-K binding
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :Grepper -open -cword -noprompt<cr>
nnoremap <leader>f :Grepper<cr>
nnoremap <leader>fw :Grepper -open -cword -noprompt<cr>
nnoremap <leader>fr :Grepper -open -dir repo,filecwd -cword -noprompt<cr>
nnoremap <leader>fs :Grepper -open -side -dir repo,filecwd -cword -noprompt<cr>

let g:grepper               = {
      \ 'tools':          ['rg', 'ag', 'git'],
      \ 'jump':           0,
      \ 'simple_prompt':  1,
      \ 'quickfix':       1,
      \ 'git':            { 'grepprg': 'git grep --no-color -nI' },
      \ 'rg':             { 'grepprg': 'rg -L --vimgrep' },
      \ 'ag':             { 'grepprg': 'ag -f --vimgrep' }
      \ }

" inc search plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

""""""""""""""""""""""""""""""
" Auto Completion
""""""""""""""""""""""""""""""
" ** OmniCppComplete **
let OmniCpp_NamespaceSearch   = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess        = 1
let OmniCpp_MayCompleteDot    = 1
let OmniCpp_MayCompleteArrow  = 1
let OmniCpp_MayCompleteScope  = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set completeopt=menuone,menu,longest,preview

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

