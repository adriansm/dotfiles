"
" cscope configurations
"
if ! has('cscope')
  finish
endif

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
