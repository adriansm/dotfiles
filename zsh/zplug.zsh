# zplug environment variables
export ZPLUG_LOADFILE=$ZSH_HOME/zplug_packages.zsh

source $ZSH_HOME/zplug/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# source plugins and add commands to $PATH
zplug load

