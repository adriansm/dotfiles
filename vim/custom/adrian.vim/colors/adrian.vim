set background=dark
hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'adrian'

hi Normal guifg=#e4e4e4 ctermfg=254 guibg=#202020 gui=NONE cterm=NONE

" Misc {{{1
hi Boolean        guifg=#af97df ctermfg=98  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Character      guifg=#9d7ff2 ctermfg=141 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Comment        guifg=#767676 ctermfg=243 ctermbg=NONE gui=NONE cterm=NONE
hi Conditional    guifg=#F6DA7B ctermfg=222 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Constant       guifg=#87dfdf ctermfg=116 ctermbg=NONE gui=NONE cterm=NONE
hi Cursor         guifg=#eeeeee ctermfg=15  ctermbg=247  gui=NONE guibg=#8DA1A1
hi CursorIM       guifg=#eeeeee ctermfg=15  ctermbg=247  gui=bold guibg=#8da1a1 cterm=NONE
hi Debug          guifg=#55747c ctermfg=66  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Define         guifg=#F6DA7B ctermfg=222 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Delimiter      guifg=#55747c ctermfg=66  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Directory      guifg=#ffaf87 ctermfg=216 ctermbg=NONE gui=NONE cterm=NONE
hi Exception      guifg=#c67c48 ctermfg=173 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Float          guifg=#87dfdf ctermfg=116 ctermbg=NONE gui=NONE cterm=NONE
hi Function       guifg=#82c057 ctermfg=107 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Identifier     guifg=#ffaf87 ctermfg=216 ctermbg=NONE gui=NONE cterm=NONE
hi Ignore         guifg=#55747c ctermfg=66
hi Include        guifg=#c67c48 ctermfg=173 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Keyword        guifg=#c67c48 ctermfg=173 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Label          guifg=#F6DA7B ctermfg=222 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Macro          guifg=#F6DA7B ctermfg=222 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi MatchParen     guifg=#df005f ctermfg=161 ctermbg=NONE gui=bold cterm=bold
hi NonText        guifg=#ff00af ctermfg=199 ctermbg=NONE gui=bold cterm=bold
hi Number         guifg=#87dfdf ctermfg=116 ctermbg=NONE gui=NONE cterm=NONE
hi Operator       guifg=#F6DA7B ctermfg=222 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi PreCondit      guifg=#c67c48 ctermfg=173 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi PreProc        guifg=#ffdfaf ctermfg=223 ctermbg=NONE gui=NONE cterm=NONE
hi Question       guifg=#c98de6 ctermfg=102 ctermbg=NONE gui=bold guibg=NONE cterm=NONE
hi Repeat         guifg=#c67c48 ctermfg=173 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Scrollbar      guibg=NONE
hi Special        guifg=#dfafaf ctermfg=181 ctermbg=NONE gui=NONE cterm=NONE
hi SpecialChar    guifg=#55747c ctermfg=66  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi SpecialComment guifg=#55747c ctermfg=66  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi SpecialKey     guifg=#6c6c6c ctermfg=248 ctermbg=NONE gui=NONE cterm=NONE
hi Statement      guifg=#afdf87 ctermfg=150 ctermbg=NONE gui=NONE cterm=NONE
hi StorageClass   guifg=#95d5f1 ctermfg=117 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi String         guifg=#87afdf ctermfg=110 ctermbg=NONE gui=NONE cterm=NONE
hi Structure      guifg=#9876e0 ctermfg=117 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Tag            guifg=#55747c ctermfg=66  ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Title          guifg=#9d7ff2 ctermfg=141 ctermbg=NONE gui=bold guibg=NONE cterm=NONE
hi Todo           guifg=#ffdfaf ctermfg=223 ctermbg=NONE gui=NONE cterm=NONE guibg=NONE
hi Type           guifg=#87dfaf ctermfg=115 ctermbg=NONE gui=NONE cterm=NONE
hi Typedef        guifg=#95d5f1 ctermfg=117 ctermbg=NONE gui=NONE guibg=NONE cterm=NONE
hi Underlined     guifg=#c98de6 ctermfg=192 ctermbg=NONE gui=underline guibg=NONE cterm=NONE
hi VertSplit      guifg=#afd787 ctermfg=150 guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi WildMenu       guifg=#101010 ctermfg=0   guibg=#f6da8b ctermbg=222 gui=bold cterm=NONE

" Cursor lines {{{1
hi CursorColumn ctermfg=NONE guibg=#303030 ctermbg=236 gui=NONE cterm=NONE
hi CursorLine   ctermfg=NONE guibg=#303030 ctermbg=236 gui=NONE cterm=NONE

" Tabline {{{1
hi TabLine     guifg=#808080 ctermfg=244 guibg=#303030 ctermbg=236 gui=NONE cterm=NONE
hi TabLineFill guifg=#dfdfaf ctermfg=187 guibg=#303030 ctermbg=236 gui=NONE cterm=NONE
hi TabLineSel  guifg=#e4e4e4 ctermfg=254 guibg=#303030 ctermbg=236 gui=bold cterm=bold

" Statusline {{{1
hi StatusLine   guifg=#e4e4e4 ctermfg=254 guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE
hi StatusLineNC guifg=#808080 ctermfg=244 guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE

" Number column {{{1
hi CursorLineNr guifg=#878787 ctermfg=102 guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE
hi LineNr       guifg=#878787 ctermfg=102 guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE

" Color column {{{1
hi ColorColumn ctermfg=NONE guibg=#333333 ctermbg=237 gui=NONE cterm=NONE

" Diff & Signs {{{1
hi DiffAdd    guifg=#87ff5f ctermfg=119 ctermbg=NONE gui=NONE cterm=NONE
hi DiffChange guifg=#fdd05f ctermfg=227 ctermbg=NONE gui=NONE cterm=NONE
hi DiffDelete guifg=#df5f5f ctermfg=167 ctermbg=NONE gui=NONE cterm=NONE
hi DiffText   guifg=#ff5f5f ctermfg=203 guibg=#5f0000 ctermbg=52 gui=bold cterm=bold
hi SignColumn guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE

" Folds {{{1
hi FoldColumn ctermfg=102 ctermbg=237 cterm=NONE guifg=#878787 guibg=#3a3a3a gui=NONE
hi Folded     ctermfg=102 ctermbg=237 cterm=NONE guifg=#878787 guibg=#3a3a3a gui=NONE

" Search {{{1
hi IncSearch guifg=#c0c0c0 ctermfg=7 guibg=#005fff ctermbg=27  gui=NONE cterm=NONE
"hi Search    guifg=#c0c0c0 ctermfg=7 guibg=#df005f ctermbg=161 gui=NONE cterm=NONE
hi Search    guifg=#4e4e4e ctermfg=239 guibg=#d7875f ctermbg=173 gui=NONE cterm=NONE

" Messages {{{1
hi Error      guifg=#eeeeee ctermfg=255 guibg=#df005f ctermbg=161  gui=NONE cterm=NONE
hi ErrorMsg   guifg=#eeeeee ctermfg=255 guibg=#df005f ctermbg=161  gui=NONE cterm=NONE
hi ModeMsg    guifg=#afff87 ctermfg=156               ctermbg=NONE gui=bold cterm=bold
hi MoreMsg    guifg=#c0c0c0 ctermfg=7   guibg=#005fdf ctermbg=26   gui=NONE cterm=NONE
hi WarningMsg guifg=#c0c0c0 ctermfg=7   guibg=#005fdf ctermbg=26   gui=NONE cterm=NONE

" Visual {{{1
hi Visual    guifg=#c0c0c0 ctermfg=7 guibg=#005f87 ctermbg=24 gui=reverse cterm=NONE
hi VisualNOS guifg=#c0c0c0 ctermfg=7 guibg=#5f5f87 ctermbg=60 gui=reverse cterm=NONE

" Pmenu {{{1
hi Pmenu      guifg=#e4e4e4 ctermfg=254 guibg=#4e4e4e ctermbg=239 gui=NONE cterm=NONE
hi PmenuSbar  ctermfg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi PmenuSel   guifg=#df5f5f ctermfg=167 guibg=#444444 ctermbg=238 gui=bold cterm=bold
hi PmenuThumb ctermfg=NONE guibg=#df5f5f ctermbg=167 gui=NONE cterm=NONE

" Spell {{{1
hi SpellBad   guifg=#c0c0c0 ctermfg=7 guibg=#df5f5f ctermbg=167 gui=NONE cterm=NONE
hi SpellCap   guifg=#c0c0c0 ctermfg=7 guibg=#005fdf ctermbg=26  gui=NONE cterm=NONE
hi SpellLocal guifg=#c0c0c0 ctermfg=7 guibg=#8700af ctermbg=91  gui=NONE cterm=NONE
hi SpellRare  guifg=#c0c0c0 ctermfg=7 guibg=#00875f ctermbg=29  gui=NONE cterm=NONE

" Quickfix {{{1
hi qfLineNr     ctermfg=240 ctermbg=NONE cterm=NONE guifg=#585858 guibg=NONE gui=NONE
hi qfSeparator  ctermfg=243 ctermbg=NONE cterm=NONE guifg=#767676 guibg=NONE gui=NONE
hi QuickFixLine guifg=#e4e4e4 ctermfg=254 guibg=#005f87 ctermbg=24 gui=NONE cterm=NONE

" C/C++ {{{1
" hi! link cMacroName Macro hi! link cConstant cMacroName
" hi! link cPreInclude String
" hi! link cPreProcRegion NormalFg
" hi! link cUserLabel NormalFg
" hi! link cDataStructureKeyword Keyword
" hi! link cDataStructure Structure
" hi! link cFunction Function
" hi! link cppDestructor cFunction
" hi! link cSemicolon Keyword
" hi! link cComma Keyword
" " call s:Hi('cppAfterColon', s:p.cStructField)
" hi! link cppBeforeColon cDataStructure
" hi! link cStructField Identifier
" hi! link cppNullptr Keyword
" hi! link cppTemplate Keyword
" hi! link cTypedef Keyword
" hi! link cppTypeName Keyword
" hi! link cSpecial Keyword
" hi! link cEnum Keyword
" hi! link cSomeMacro cMacroName

" Plugin: vim-easymotion {{{1
hi EasyMotionTarget        guifg=#ffff5f ctermfg=227 ctermbg=NONE gui=bold cterm=bold
hi EasyMotionTarget2First  guifg=#df005f ctermfg=161 ctermbg=NONE gui=NONE cterm=NONE
hi EasyMotionTarget2Second guifg=#ffff5f ctermfg=227 ctermbg=NONE gui=NONE cterm=NONE

" Plugin: cocnvim {{{1
hi default link CocSem_namespace Identifier
hi default link CocSem_type Type
hi default link CocSem_class Structure
hi default link CocSem_enum Type
hi default link CocSem_interface Type
hi default link CocSem_struct Structure
hi default link CocSem_typeParameter Type
" TODO pick colors for param/var
hi CocSem_parameter guifg=#fafafa ctermfg=254 guibg=NONE gui=NONE cterm=NONE
" hi default link CocSem_parameter Normal
hi CocSem_variable guifg=#e4b4b4 ctermfg=254 guibg=NONE gui=NONE cterm=NONE
hi default link CocSem_variable Normal
hi default link CocSem_property Identifier
hi default link CocSem_enumMember Constant
hi default link CocSem_event Identifier
hi default link CocSem_function Function
hi default link CocSem_method Function
hi default link CocSem_macro Macro
hi default link CocSem_keyword Keyword
hi default link CocSem_modifier StorageClass
hi default link CocSem_comment Comment
hi default link CocSem_string String
hi default link CocSem_number Number
hi default link CocSem_regexp Normal
hi default link CocSem_operator Operator

" Plugin: vim-signify {{{1 hi SignifySignAdd    guifg=#87ff5f ctermfg=119 guibg=NONE ctermbg=NONE gui=bold cterm=bold hi SignifySignChange guifg=#ffff5f ctermfg=227 guibg=NONE ctermbg=NONE gui=bold cterm=bold hi SignifySignDelete guifg=#df5f5f ctermfg=167 guibg=NONE ctermbg=NONE gui=bold cterm=bold

" Plugin: vim-startify {{{1
hi StartifyBracket guifg=#585858 ctermfg=240 ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFile    guifg=#eeeeee ctermfg=255 ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFooter  guifg=#585858 ctermfg=240 ctermbg=NONE gui=NONE cterm=NONE
hi StartifyHeader  guifg=#87df87 ctermfg=114 ctermbg=NONE gui=NONE cterm=NONE
hi StartifyNumber  guifg=#ffaf5f ctermfg=215 ctermbg=NONE gui=NONE cterm=NONE
hi StartifyPath    guifg=#8a8a8a ctermfg=245 ctermbg=NONE gui=NONE cterm=NONE
hi StartifySection guifg=#dfafaf ctermfg=181 ctermbg=NONE gui=NONE cterm=NONE
hi StartifySelect  guifg=#5fdfff ctermfg=81  ctermbg=NONE gui=NONE cterm=NONE
hi StartifySlash   guifg=#585858 ctermfg=240 ctermbg=NONE gui=NONE cterm=NONE
hi StartifySpecial guifg=#585858 ctermfg=240 ctermbg=NONE gui=NONE cterm=NONE

" Neovim {{{1
if has('nvim')
  hi NormalFloat guifg=#bcbcbc ctermfg=250 ctermbg=237 guibg=#3a3a3a gui=NONE cterm=NONE
  hi EndOfBuffer  ctermfg=235  guifg=#202020 ctermbg=NONE gui=NONE cterm=NONE
  hi TermCursor   ctermfg=NONE guibg=#ff00af ctermbg=199 gui=NONE cterm=NONE
  hi TermCursorNC ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Whitespace guifg=#3a3a3a ctermfg=237 ctermbg=NONE gui=NONE cterm=NONE
endif

" Terminal colors
let g:terminal_color_0 = '#3f3f3f'
let g:terminal_color_1 = '#705050'
let g:terminal_color_2 = '#60b48a'
let g:terminal_color_3 = '#dfaf8f'
let g:terminal_color_4 = '#506070'
let g:terminal_color_5 = '#dc8cc3'
let g:terminal_color_6 = '#8cd0d3'
let g:terminal_color_7 = '#dcdccc'
let g:terminal_color_8 = '#709080'
let g:terminal_color_9 = '#dca3a3'
let g:terminal_color_10 = '#c3bf9f'
let g:terminal_color_11 = '#f0dfaf'
let g:terminal_color_12 = '#94bff3'
let g:terminal_color_13 = '#ec93d3'
let g:terminal_color_14 = '#93e0e3'
let g:terminal_color_15 = '#ffffff'

" Nvim Cmp {{{1
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
