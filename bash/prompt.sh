#!/bin/bash

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

export _TITLE_PREFIX=""

find_work_dir() {
  local shortcuts="$HOME:~"
  local p=$PWD
  export pwd2=""

  for pair in $shortcuts; do
    local w=$p
    local n=${pair/*:/}
    local l=${pair/:*/}
    p="${w#$l}";
    [ "${w}" != "${p}" ] && pwd2="$n" && break;
  done
  pwd2="${pwd2}${p}"
}

find_title_prefix() {
  if [ -n "$TARGET_PRODUCT" ]; then
    local product=$TARGET_PRODUCT
    local variant=$TARGET_BUILD_VARIANT

    if [ -n "$adb_info" ]; then
      _TITLE_PREFIX="[$product-$variant ${adb_info}] "
    else
      _TITLE_PREFIX="[$product-$variant] "
    fi
  elif [ -n "$adb_info" ]; then
    _TITLE_PREFIX="[${adb_info}] "
  #elif [ -n "$(g3_client)" ]; then
    #_TITLE_PREFIX="[CitC $(g3_client)] "
  else
    _TITLE_PREFIX=""
  fi
}

# avoid android scripts to mess this up
STAY_OFF_MY_LAWN=true

case "$OSTYPE" in
  *darwin*) # mac
    export PS1="\[$txtgrn\]\u@\h\[$txtrst\]:\[$txtblu\]\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
    ;;
  linux*) # linux
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"
    export PROMPT_COMMAND+="find_title_prefix; find_work_dir"
    PS1="\${debian_chroot:+(\$debian_chroot)}\[$bldgrn\]\u@\h\[$txtrst\]:\[$bldblu\]\$pwd2 \[$txtrst\]\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
    ;;
esac

# set title if xterm
case "$TERM" in
xterm*|rxvt*|screen*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\${_TITLE_PREFIX}\u@\h: \$pwd2\a\]$PS1"
  ;;
*)
  ;;
esac