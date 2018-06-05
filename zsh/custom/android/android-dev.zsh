function aenv()
{
  local target=$1

  if [[ $SHELL == *"zsh" ]]; then
    autoload bashcompinit && bashcompinit

    # workaround to support bash for loops in android's envsetup
    setopt shwordsplit
  fi

  if [ "$target" = "" ]; then
    echo "No target specified!"
    return 1
  fi

  T=$(get_android_top_dir)
  if [ -d "$T" ]; then
    # try to find a local out folder for gitc repo
    if [ -z "$OUT_DIR" ] && [[ $T = "/gitc/"* ]]; then
      local localdir=$(readlink -f ${LOCAL_GITC_DIR}/$(basename $T))
      if [ -d $localdir ]; then
        local outdir=$localdir/out
        echo "Setting OUT_DIR to: $outdir"
        export OUT_DIR=$outdir
      fi
    fi
    [[ $target != *"-"* ]] && target=${target}-userdebug

    echo "Setting up environment for target: ${target}"
    source $T/build/envsetup.sh
    lunch ${target}
  else
    echo "Couldn't locate top of the tree"
  fi
}

function get_android_top_dir()
{
  find_top_dir build/envsetup.sh
}

### android shortcuts from build/envsetup.sh
function croot()
{
  T=$(get_android_top_dir)

  # fallback to finding top of repo
  [ -n "$T" ] || T=$(find_top_dir .repo/manifests/default.xml)

  if [ -n "$T" ]; then
    \cd $T
  else
    echo "Couldn't locate the top of the tree.  Try setting TOP."
  fi
}

function mclion()
{
  export SOONG_GEN_CMAKEFILES=1
  export SOONG_GEN_CMAKEFILES_DEBUG=1
  local T=$(get_android_top_dir)
  if [ "$T" ]; then
    make -C $T -f build/core/main.mk $@
  else
    echo "Couldn't locate the top of the tree.  Try setting TOP."
    return 1
  fi
}

function flashall()
{
  T=$(get_android_top_dir)
  local f="$T/vendor/google/tools/flashall"
  local extra_args=
  [ -n "$ANDROID_SERIAL" ] && extra_args="-s $ANDROID_SERIAL"
  [ -x "$f" ] && $f $extra_args $@
}

function repo ()
{
  if [[ "$1" = "sync" ]]; then
    if [[ "$*" != *" -c"* ]]; then
      echo "Sync without -c; aborting."
      return 1
    fi;
  fi;
  command repo "$@"
}
