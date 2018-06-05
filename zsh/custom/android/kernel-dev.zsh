#!/usr/bin/zsh

function is_kernel_environment()
{
  T=$(get_android_top_dir)
  test -n "$T" -a -x "$T/build/build.sh" -a \
    -n "$BRANCH" -a -n "$ARCH" -a -d "$ROOT_DIR" -a -n "$KERNEL_DIR" -a \
    -d "$ROOT_DIR/$KERNEL_DIR"
}

# TODO: set kernel prebuilt path on android env, it's harder with kernel modules
function akenv()
{
  local T=$1
  if [ -z "$T" ]; then
    if [ -n "$TARGET_PRODUCT" -d ~kernel -a -d ~kernels/$TARGET_PRODUCT ]; then
      T=~kernels/$TARGET_PRODUCT
    else
      T=$(get_android_top_dir)
    fi
  fi
  local KROOT=$(find_top_in_dir $T build/build.sh)

  if [ -n "$KROOT" -a -x "$KROOT/build/build.sh" -a -d "$KROOT/out" ]; then
    local kernel_images=(Image.gz-dtb)

    for k in kernel_images; do
      local img="$KROOT/out/*/dist/$k"
    done
  fi
}

function kenv()
{
  T=$(get_android_top_dir)
  if [ -n "$T" -a -x "$T/build/build.sh" -a -f "$T/build/envsetup.sh" ]; then
    cd $T && source $T/build/envsetup.sh
    if ! is_kernel_environment; then
      echo "Invalid envsetup.sh, unable to set kernel env"
      return 1
    fi

    export COMMON_OUT_DIR=$(readlink -m ${ROOT_DIR}/out/${BRANCH})
    export OUT_DIR=${COMMON_OUT_DIR}/$KERNEL_DIR
    export CLANG_TRIPLE CROSS_COMPILE CROSS_COMPILE_ARM32 ARCH SUBARCH

    export TMPDIR=$T/out/.tmp/
    mkdir -p $TMPDIR

    export DIST_DIR=$(readlink -m ${DIST_DIR:-${COMMON_OUT_DIR}/dist})
  else
    echo "Unable to find kernel top dir"
    return 1
  fi
}

function kkmake()
{
  is_kernel_environment || kenv
  if [ $? -ne 0 ]; then
    echo "Unable to setup kernel environment"
    return 1
  fi

  if [ ! -f $OUT_DIR/.config ]; then
    echo "No defconfig found, run kernel make first"
    return 1
  fi

  if [ -n "${CC}" ]; then
    local CC_ARG="CC=${CC}"
  fi
  make -C $ROOT_DIR/${KERNEL_DIR} O=${OUT_DIR} ${CC_ARG} $@
}

function kdist()
{
  if ! is_kernel_environment; then
    echo "Environment not set or kernel build hasn't been done. Cannot proceed"
    return 1
  fi

  if [ -n "${EXTRA_CMDS}" ]; then
    echo "========================================================"
    echo " Running extra build command(s):"
    eval ${EXTRA_CMDS}
  fi

  typeset -a OVERLAYS_OUT
  for ODM_DIR in ${ODM_DIRS}; do
    OVERLAY_DIR=${ROOT_DIR}/device/${ODM_DIR}/overlays

    if [ -d ${OVERLAY_DIR} ]; then
      OVERLAY_OUT_DIR=${OUT_DIR}/overlays/${ODM_DIR}
      mkdir -p ${OVERLAY_OUT_DIR}
      make -C ${OVERLAY_DIR} DTC=${OUT_DIR}/scripts/dtc/dtc OUT_DIR=${OVERLAY_OUT_DIR}
      OVERLAYS="$(find ${OVERLAY_OUT_DIR} -name "*.dtbo")"
      OVERLAYS_OUT+=$OVERLAYS
    fi
  done

  mkdir -p ${DIST_DIR}
  typeset -a DIST_FILES
  for f in ${(@f)FILES}; do
    DIST_FILES+=$OUT_DIR/$f;
  done
  if [ -n "${IN_KERNEL_MODULES}" ]; then
    local kmods="$(find ${OUT_DIR} -path ${OUT_DIR}/dist -prune -o -type f -name "*.ko" -print)"
    for f in ${(@f)kmods}; do DIST_FILES+=$f; done
  fi

  typeset -a COPY_FILES
  for f in $DIST_FILES; do
    local dist_fn=$DIST_DIR/$(basename $f)
    if [ -f $f ] && ( [ ! -f $dist_fn ] || ! cmp -s $f $dist_fn ); then
      COPY_FILES+=$f
    fi
  done

  echo "========================================================"
  if [ -n "$COPY_FILES" -o -n "$OVERLAYS_OUT" ]; then
    echo " Copying files"
    for FILE in ${COPY_FILES}; do
      local fn=${FILE#${OUT_DIR}/}
      echo "  $fn "
      cp -a ${FILE} ${DIST_DIR}/
    done

    for FILE in ${OVERLAYS_OUT}; do
      OVERLAY_DIST_DIR=${DIST_DIR}/$(dirname ${FILE#${OUT_DIR}/overlays/})
      echo "  ${FILE#${OUT_DIR}/}"
      mkdir -p ${OVERLAY_DIST_DIR}
      cp ${FILE} ${OVERLAY_DIST_DIR}/
    done
    echo "========================================================"
    echo " Files copied to $(print -rD ${DIST_DIR})"
  else
    echo "No artifacts have changed!"
  fi
}

function kk()
{
  kimake $@ && kdist
}

function kimake()
{
  SKIP_MRPROPER=1 SKIP_DEFCONFIG=1 kmake $@
}

function kmake()
{
  T=$(get_android_top_dir)
  if [ "$T" ] && [ -x "$T/build/build.sh" ]; then
    local pre=
    export TMPDIR=$T/out/.tmp/
    mkdir -p $TMPDIR

    if [ -x "$(command -v intercept-build)" ]; then
      pre="intercept-build --cdb ${T}/compile_commands.json"
    elif [ -x "$(command -v bear)" ]; then
      pre="bear --cdb ${T}/compile_commands.json"
    fi
    [ -z "$SKIP_MRPROPER" ] || pre+=" --append"

    ( \cd $T && export OUT_DIR= && ${=pre} ./build/build.sh $@)
  else
    echo "Not in a kernel repo, make sure build/build.sh exists on top of tree"
  fi
}

function get_kernel_root()
{

  T=$(find_top_dir scripts/link-vmlinux.sh)
  if [ ! -d "$T" ]; then
    T=$(find_top_dir build/build.config)
    if [ -z "$KERNEL_DIR" -a -d "$T" ]; then
      local KDIR=$(cat $T/build/build.config | grep "^KERNEL_DIR\=")
      local KERNEL_DIR=${KDIR//KERNEL_DIR=/}
    fi

    if [ -n "$KERNEL_DIR" -a -d "$T/$KERNEL_DIR" ]; then
      T=$T/$KERNEL_DIR
    else
      return 1
    fi
  fi
  echo $T
  return 0
}

function kroot()
{
  local subdir
  local kernel_root=$(get_kernel_root)

  if [ -z "$kernel_root" ]; then
    echo "Unable to find kernel root"
    return 1
  fi

  if [ -z "$1" ]; then
    \cd $kernel_root
  else
    # try different combinations of folder
    while [ -n "$1" ]; do
      if [ -d $kernel_root/$1 ]; then
        \cd $kernel_root/$1
        return 0
      fi
      shift
    done
    echo "Couldn't find subdir at kernel root ($(print -rD $kernel_root))"
  fi
}

function kctags()
{
  local kernel_top=$(get_kernel_root)
  if [[ $? -ne 0 ]]; then
    echo "Kernel root not found"
    return 1
  fi
  local path=${1:-$PWD}

  ctags -R $path $kernel_top/include $kernel_top/arch/arm64/include
}

function klog()
{
  while true; do
    adb wait-for-device root && adb shell -t dmesg -w
  done
}

function kcheckpatch()
{
  local args=${@:-$(git format-patch -o $(mktemp -d) -1)}
  ( kroot && ./scripts/checkpatch.pl $args )
}

# kernel paths shourtcuts
function kdts()
{
  kroot arch/${ARCH:-arm64}/boot/dts
}

alias kdrm="kroot drivers/gpu/drm"
alias kmdss="kroot drivers/video/msm/mdss drivers/video/fbdev/msm"
