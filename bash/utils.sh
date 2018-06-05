#!/bin/bash

function block_until_changed() {
  if [ ! -f "$1" ]; then
    echo "Invalid filename provided: $1"
    return 1
  fi
  local filename=$(readlink -f $1)

  echo "Blocking until file '$filename' is modified"
  local last_mod=$(stat $filename --printf=%Y)
  local current_mod
  while [ 1 ]; do
    current_mod=$(stat $filename --printf=%Y)
    [ $last_mod != $current_mod ] && break
    sleep 1
  done
}
alias buc=block_until_changed

function fixtmux() {
    eval $(tmux show-env -s)
}

