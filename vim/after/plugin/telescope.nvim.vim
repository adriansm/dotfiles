if !has('nvim') | finish | endif

lua << EOF
require('telescope').setup()

EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap ;; <cmd>Telescope buffers<cr>
nnoremap ;p <cmd>Telescope git_files<cr>
nnoremap ;o <cmd>Telescope git_files use_git_root=false<cr>
nnoremap ;h <cmd>Telescope help_tags<cr>
nnoremap ;g <cmd>Telescope live_grep<cr>
nnoremap ;r <cmd>Telescope grep_string<cr>

nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>p <cmd>Telescope git_files<cr>
nnoremap <leader>o <cmd>Telescope git_files use_git_root=false<cr>
