#!/bin/bash

source $MY_BASH_PATH/utils.sh

export EDITOR=vim

export TIMEFORMAT=$'\nreal %3lR\tuser %3lU\tsys %3lS\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"

export PATH=~/bin:~/.local/bin:$PATH

## Force tmux to start in 256 color mode ##
alias tmux='tmux -2'
