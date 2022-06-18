"
" YouCompleteMe
"
if get(g:, 'lang_completion', '') != 'ycm'
  finish
endif

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
