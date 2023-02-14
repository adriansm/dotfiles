call plug#begin(expand($VIMHOME.'/plugged'))
source $VIMHOME/init-plug.vim   " All plugins required
" Initialize plugin system
call plug#end()

"
" Local plugins
"
set rtp^=$VIMHOME/custom/adrian.vim

source $VIMHOME/init-minimal.vim
source $VIMHOME/init-coding.vim " All required to get coding including syntax and code completion

if exists('g:vscode') || exists("g:gui_oni")
    let g:lang_completion = 'vscode'
else
    source $VIMHOME/init-ui.vim     " All UI components such as color scheme
endif

