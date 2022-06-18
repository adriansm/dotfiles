"
" Denite options
"
if ! exists(":Denite")
  finish
endif

"   ;         - Browser currently open buffers
"   <leader>o - Browse list of files in current directory
"   <leader>p - Browse list of files in project directory
nmap ; :Denite buffer -split=floating<CR>i
nmap <leader>o :Denite file/rec -split=floating<CR>i
nmap <leader>p :DeniteProjectDir file/rec -split=floating<CR>i

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

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  let w:persistent_cursorline = 1

  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> o
        \ denite#do_map('do_action', 'open')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> s
        \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> v
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> /
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select')
  nnoremap <silent><buffer><expr> x
        \ denite#do_map('toggle_select')
  nnoremap <silent><buffer> <C-j> j
  nnoremap <silent><buffer> <C-k> k
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
  imap <silent><buffer> <C-j> <Plug>(denite_filter_quit)j
  imap <silent><buffer> <C-k> <Plug>(denite_filter_quit)k
  nmap <silent><buffer> <C-j> <Plug>(denite_filter_quit)j
  nmap <silent><buffer> <C-k> <Plug>(denite_filter_quit)k
endfunction
