local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
  return
end

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

-- " nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
-- "nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
-- " nnoremap <silent> gh :Lspsaga lsp_finder<CR>
-- " nnoremap <silent> gp :Lspsaga preview_definition<CR>

