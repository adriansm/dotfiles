" Vim syntax file
" Language: Protobuf message (not Proto descriptor)
" Maintainer: Michael Roger Brauwerman (michaelroger@google.com)
" Derived from tutorial at http://vim.wikia.com/wiki/Creating_your_own_syntax_files

" Features:
" Highlighting of keys and values of known types (string, int, hex, boolean)
" Detection of {} and <> and [] regions

" Bugs:
" Doesn't auto-indent inside {} and <> and []
" I tried to get rainbow-brackets working , but couldn't so I deleted the code.

" Add this to your .vimrc sources
" au BufRead,BufNewFile *.pb.txt setfiletype protobuf
" au BufRead,BufNewFile *.asciipb setfiletype protobuf

if exists("b:current_syntax")
  finish
endif

"A literal SubMessage Object, used as a value
syn region SubMessage start="{" end="}" fold transparent contains=Message,SubMessage,MessageFieldName,DottedFieldName

"A literal Message Object, used as a value
syn region Message start="<" end=">" fold transparent contains=Message,SubMessage,MessageFieldName,DottedFieldName

"A literal Message Object, used as a value
syn region DottedFieldName start="\[" end="\]" fold transparent contains=MessageFieldName

syn match Comment "#.*$"
syn match Comment "#.*$"

" Regular int like number with - + or nothing in front
syn match Number '\d\+' contained display
syn match Number '[-+]\d\+' contained display

" Regular hex number with 0x in front, and optional -+ in front of that
syn match Number '0x[[:xdigit:]]\+' contained display
syn match Number '[-+]0x[[:xdigit:]]\+' contained display

" Floating point number with decimal no E or e (+,-)
syn match Number '\d\+\.\d*' contained display
syn match Number '[-+]\d\+\.\d*' contained display

" Floating point like number with E and no decimal point (+,-)
syn match Number '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+' contained display
syn match Number '\d[[:digit:]]*[eE][\-+]\=\d\+' contained display

" Floating point like number with E and decimal point (+,-)
syn match Number '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display
syn match Number '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display

syn match Number    "0[xX][0-9a-fA-F]\+\>" contains=protodumpHexX display
syn match HexX         "0[xX]" contained contains=NONE display

" TODO(michaelroger) Add other valud forms of boolean
syn match Boolean '\<true\>\|\<false\>'

syn region String start="\"" end="\""

" Field name defined in the .proto. This is the "key" in a "key-value" pair.
" TODO(michaelroger) add support for digits and underscore
syn match MessageFieldName '^[[:space:]]*[[:alpha:]_][[:alpha:][:digit:]_]*' nextgroup=Colon skipwhite

" TODO(michaelroger) Is there a way to bundle Number,String,Message into class?
syn match Colon ':' nextgroup=Number,String,Boolean,Comment,Message,SubMessage skipwhite


setlocal indentexpr=GetProtodumpIndent()
setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=*/,0<,0>,0[,0]

function! GetProtodumpIndent()
    let pnum = prevnonblank(v:lnum - 1)
    if pnum == 0
       return 0
    endif
    let line = getline(v:lnum)
    let pline = getline(pnum)
    let ind = indent(pnum)
    
    if pline =~ '{\s*$\|[\s*$\|(\s*$\|<\s*$'
      let ind = ind + &sw
    endif
    if pline =~ '}\s*$\|]\s*$\|)\s*$\|>\s*$'
        let ind = ind - &sw
    endif
    return ind
endfunction


hi def link Number Constant
hi def link String Constant
hi def link MessageFieldName Identifier
hi def link Comment Comment
hi def link Boolean Boolean
hi def link Colon SpecialChar
hi def link protodumpHexX SpecialChar

setlocal commentstring=#%s
setlocal matchpairs=(:),{:},[:],<:>
let b:current_syntax  = "protobuf"
