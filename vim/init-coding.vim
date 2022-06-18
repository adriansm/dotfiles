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
" ctags
"

" build tags of your own project with \tg
nnoremap <expr> <leader>tg ':!ctags -f '.projectroot#guess().'/tags -R '.projectroot#guess().' <cr><cr>'

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


let g:mwDefaultHighlightingPalette = 'extended'
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev


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

