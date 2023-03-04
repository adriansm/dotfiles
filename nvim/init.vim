if filereadable(expand($HOME.'/.vimrc.local'))
  source $HOME/.vimrc.local
else
  " bootstrap lazy.nvim, LazyVim and your plugins
  lua require("config.lazy").setup()
end

