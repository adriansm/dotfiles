return {
  {
    "editorconfig/editorconfig-vim",     -- Syntax using .editorconfig files
    config = function()
      vim.g.EditorConfig_max_line_indicator = "fill"
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
    name = "colorizer",
    config = true,
  },
  {
    "kana/vim-operator-user",
    dependencies = { "rhysd/vim-clang-format" },
    cond = (vim.g.enable_clang_format ~= 0),
    config = function()
      vim.cmd[[
        let g:clang_format#detect_style_file = 1
        let g:clang_format#auto_formatexpr = 1
        let g:clang_format#auto_format_git_diff = 1
        let g:clang_format#auto_format_git_diff_fallback = "pass"

        autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
        autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
        autocmd FileType c,cpp,objc map <buffer> = <Plug>(operator-clang-format)
      ]]
    end,
  },
}
