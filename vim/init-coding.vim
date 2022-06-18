"
" Coding Vim Settings
"
" Settings taken over the years that have considerably helped
" coding a lot easier, some dependencies on external plugins
" are expected
"

" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

"
" cscope
"
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


"
" ctags
"

" build tags of your own project with \tg
nnoremap <expr> <leader>tg ':!ctags -f '.projectroot#guess().'/tags -R '.projectroot#guess().' <cr><cr>'


"
" YouCompleteMe
"
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

  let g:ycm_enable_diagnostic_signs = 1
  let g:ycm_enable_diagnostic_highlighting = 0
  let g:ycm_open_loclist_on_ycm_diags = 1 "default 1
endif


"
" COC options
"

if get(g:, 'lang_completion', '') == 'coc'
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gh :call CocActionAsync('doHover')<CR>
  vmap <silent> gf <Plug>(coc-format-selected)

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[d` and `]d` to navigate diagnostics
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)

  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif
endif


"
" Language Server Completion
"
if get(g:, 'lang_completion', '') == 'lps'
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


if get(g:, "enable_clang_format", 1)
  "
  " Clang Formatter
  "
  let g:clang_format#style_options = {
              \ "AccessModifierOffset" : -4,
              \ "AllowShortIfStatementsOnASingleLine" : "true",
              \ "AlwaysBreakTemplateDeclarations" : "true",
              \ "Standard" : "C++11"}

  let g:clang_format#detect_style_file = 1
  let g:clang_format#auto_formatexpr = 1

  " map to <Leader>cf in C++ code
  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

  " if you install vim-operator-user
  autocmd FileType c,cpp,objc map <buffer> = <Plug>(operator-clang-format)

  " Toggle auto formatting:
  nmap <Leader>C :ClangFormatAutoToggle<CR>
endif


"
" Syntastic
"
function! DetectCheckPatch(file)
  let topdir = fnamemodify(finddir('.git', a:file . ';'), ':h')

  if !filereadable(topdir . '/Kbuild')
    return
  endif

  if executable(topdir . '/scripts/checkpatch.pl')
    let g:syntastic_c_checkpatch_exec = fnamemodify(topdir . '/scripts/checkpatch.pl', ':p')
    let b:syntastic_checkers = ["checkpatch"]
    let b:syntastic_mode = "active"
  endif
endfunction

augroup kernel
  autocmd BufNewFile,BufReadPost *.[ch] :call DetectCheckPatch(expand('<afile>:p'))
augroup END

" rely on completer for checking
let g:syntastic_c_checkers             = []
let g:syntastic_c_check_header           = 1
let g:syntastic_python_checkers             = []
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
"let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_error_symbol             = 'x'
let g:syntastic_warning_symbol           = '!'

let g:syntastic_mode_map = {
      \ "mode": "active",
      \ "active_filetypes": ["ruby", "php"],
      \ "passive_filetypes": ["java", "cpp"] }


"
" UltiSnips
"
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"


"
" Search/Grep
"
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ -f\ --nogroup\ --nocolor

  " Replace ack searcher
  let g:ackprg = 'ag --smart-case -f --vimgrep'
  cnoreabbrev ag Ack
endif

" quick search with ctrl-shift-K binding
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :Grepper -open -cword -noprompt<cr>
nnoremap <leader>ff :Grepper<cr>
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

"
" inc search plugin
"
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" auto hide incremental search
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

"
" Vim Easy Motion
"

"let g:EasyMotion_do_mapping = 0 " Disable default mappings

nmap s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

"
" Tcomment
"
let g:tcomment_mapleader2='<Leader>c'

"
" OmniCppComplete Autocompletion (deprecated)
"
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


"
" Git Gutter options
"
function! GlobalChangedLines(ex_cmd)
  for hunk in GitGutterGetHunks()
    for lnum in range(hunk[2], hunk[2]+hunk[3]-1)
      let cursor = getcurpos()
      silent! execute lnum.a:ex_cmd
      call setpos('.', cursor)
    endfor
  endfor
endfunction

command! -nargs=1 Glines call GlobalChangedLines(<q-args>)

" Remove triling whitespace on edited lines
autocmd BufWritePre * Glines s/\s\+$/


"
" Editor Config
"
let g:EditorConfig_max_line_indicator = "fill"
" make editorconfig work nice with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif


"
" Vim Bookmarks Plugin
"

let g:bookmark_highlight_lines = 1
let g:bookmark_auto_save = 1
let g:bookmark_manage_per_buffer = 1
let g:bookmark_disable_ctrlp = 1
let g:bookmark_auto_close = 1

" Finds the Git super-project directory based on the file passed as an argument.
function! g:BMBufferFileLocation(file)
  let filename = 'vim-bookmarks'
  let cur_dir = fnamemodify(a:file, ":p:h")
  if isdirectory(cur_dir.'/.git')
    " Current work dir is git's work tree
    let git_location = cur_dir.'/.git'
  else
    " Look upwards (at parents) for a directory named '.git'
    let git_location = finddir('.git', cur_dir.'/.;')
  endif
  if len(git_location) > 0
    return simplify(git_location.'/'.filename)
  else
    return simplify(cur_dir.'/.'.filename)
  endif
endfunction

