if !exists('g:loaded_grepper') | finish | endif

" quick search with ctrl-shift-K binding
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" nnoremap K :Grepper -open -cword -noprompt<cr>
" nnoremap <leader>ff :Grepper<cr>
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


cnoreabbrev ag GrepperAg
cnoreabbrev rg GrepperRg

set grepprg=ag\ -f\ --vimgrep
