_ANDROID_DIR=${0:h}

# where to store build output for gitc repos
export LOCAL_GITC_DIR=~/builds/gitc

# to speed up builds
export USE_CCACHE=1

function find_top_in_dir()
{
  local path=${1:A}
  local file=$2

  if [ -d $path ]; then
    local t=$path

    while [ \( ! \( -f "$t/$file" \) \) -a \( "$t" != "/" \) ]; do
      t=${t:h}
    done
    if [ -f "$t/$file" ]; then
      echo $t
    fi
  fi
}

function find_top_dir()
{
  find_top_in_dir $PWD $1
  return

  local TOPFILE=$1
  if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
    # The following circumlocution ensures we remove symlinks from TOP.
    (cd "$TOP"; PWD= /bin/pwd)
  else
    if [ -f "$TOPFILE" ] ; then
      # The following circumlocution (repeated below as well) ensures
      # that we record the true directory name and not one that is
      # faked up with symlink names.
      PWD= /bin/pwd
    else
      local HERE=$PWD
      T=
      while [ \( ! \( -f "$TOPFILE" \) \) -a \( "$PWD" != "/" \) ]; do
        \cd ..
        T=`PWD= /bin/pwd -P`
      done
      \cd "$HERE"
      if [ -f "$T/$TOPFILE" ]; then
        echo $T
      fi
    fi
  fi
}

source $_ANDROID_DIR/android-dev.zsh
source $_ANDROID_DIR/kernel-dev.zsh
source $_ANDROID_DIR/platform-tools.zsh
source $_ANDROID_DIR/alias.zsh
