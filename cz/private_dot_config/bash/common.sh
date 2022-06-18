#!/bin/bash

source $MY_BASH_PATH/utils.sh

export EDITOR=vim

export TIMEFORMAT=$'\nreal %3lR\tuser %3lU\tsys %3lS\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"

export PATH=~/bin:~/.local/bin:$PATH

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
