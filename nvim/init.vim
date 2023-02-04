if filereadable(expand($HOME.'/.vimrc.local'))
    source $HOME/.vimrc.local
end

lua require('init').setup()
