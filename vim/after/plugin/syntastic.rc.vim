if !exists('g:loaded_syntastic_checker') | finish | endif

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
