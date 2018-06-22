# oh-my-zsh libs and plugins
OH_MY_ZSH_LIBS=(
  'clipboard'
  'completion'
  'correct'
  'directories'
  'functions'
  'history'
  'key-bindings'
  'misc'
  'theme-and-appearance'
)
OH_MY_ZSH_PLUGINS=(
  'command-not-found'
  'git'
  'gitfast'
  'pip'
  'z'
)
if [[ "$OSTYPE" =~ ^darwin ]]; then
  OH_MY_ZSH_PLUGINS+=('brew' 'osx')
fi

zplug "robbyrussell/oh-my-zsh", use:"lib/{${(j:,:)OH_MY_ZSH_LIBS}}.zsh"
for p in $OH_MY_ZSH_PLUGINS; do
  zplug "plugins/${p}", from:oh-my-zsh
done

# Syntax highlighting bundle.
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

zplug "molovo/tipz"

# Local plugins
zplug "$ZSH_HOME/custom/android", from:local, use:android.plugin.zsh
zplug "$ZSH_HOME/custom/iterm2_integration", from:local, use:iterm2.plugin.zsh

# Theme
zplug "mafredri/zsh-async"
zplug "$ZSH_HOME/custom/pureprompt", from:local, use:pure.zsh, as:theme

zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
