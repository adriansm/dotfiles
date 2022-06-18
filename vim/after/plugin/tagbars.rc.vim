"
" External Tag bars
"
if exists(":NERDTreeToggle")
  noremap <C-e> :NERDTreeToggle<CR>

  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if exists(":TagbarToggle")
  map <Leader>tt :TagbarToggle<CR>
endif
