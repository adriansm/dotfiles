augroup filetypes
  autocmd BufNewFile,BufRead *.dts,*.dtsi           set filetype=dts
  autocmd BufNewFile,BufRead *.cmake,CMakeLists.txt set filetype=cmake
  autocmd BufNewFile,BufRead */.Postponed/*         set filetype=mail
  autocmd BufNewFile,BufRead *.txt                  set filetype=human
  autocmd BufNewFile,BufRead *.ctp                  set filetype=php
  autocmd BufNewFile,BufRead *.aidl,*.hal           set filetype=java
  autocmd BufNewFile,BufRead CMakeLists.txt,*.cmake set filetype=cmake
  autocmd BufNewFile,BufRead *.cmm                  set filetype=practice
  autocmd! BufRead,BufNewFile *.proto               set filetype=proto
  autocmd! BufRead,BufNewFile *.asciipb             set filetype=protobuf
  autocmd! BufRead,BufNewFile */.ssh/config.d/*     set filetype=sshconfig
augroup END
