if !exists(':NERDTreeToggle') | finish | endif

nnoremap ;e :NERDTreeToggle<CR>

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

