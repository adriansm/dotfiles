if has("win32") || has ("win64")
    let $VIMHOME = $VIM."/vimfiles"
else
    let $VIMHOME = $HOME."/.vim"
    if filereadable(expand($HOME.'/.vimrc.local'))
        source $HOME/.vimrc.local
    end
endif

call plug#begin(expand($VIMHOME.'/plugged'))
source $VIMHOME/init-plug.vim   " All plugins required
" Initialize plugin system
call plug#end()

source $VIMHOME/init-minimal.vim
source $VIMHOME/init-coding.vim " All required to get coding including syntax and code completion

if exists('g:vscode') || exists("g:gui_oni")
    let g:lang_completion = 'vscode'
else
    source $VIMHOME/init-ui.vim     " All UI components such as color scheme
endif

