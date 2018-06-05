#!/bin/zsh

# avoid conflicting with build env adb
[ -z $ADB_BIN ] && ADB_BIN=$(which adb)
[ -z $FASTBOOT_BIN ] && FASTBOOT_BIN=$(which fastboot)

#export ANDROID_ADB_SERVER_PORT=5050
unset ANDROID_SERIAL
export LAST_ANDROID_SERIAL=
export adb_info=

function myadb()
{
  local external=true
  for i in logcat shell reboot root unroot disable-verity remount bugreport install push pull; do
    if [ "$1" == "$i" ]; then
      external=false
      break
    fi
  done

  if $external; then
    $ADB_BIN $@
    return $?
  fi

  if [ -z "$ANDROID_SERIAL" ]; then
    $ADB_BIN start-server || ( echo "Unable to start adb"; return 1 )

    # Try to find connected adb device
    export ANDROID_SERIAL=$(${ADB_BIN} get-serialno 2>/dev/null)
    [ "$ANDROID_SERIAL" != "" ] || select_android_device || return 1
  fi

  set_android_prompt_info
  $ADB_BIN $@

  if [ "$?" != "0" ]; then
    local connected=$($ADB_BIN get-state 2>/dev/null)
    if [ -z "$connected" ]; then
      #echo "Trying to find if $ANDROID_SERIAL is connected"
      local fb_connected=$($FASTBOOT_BIN devices | grep ^$ANDROID_SERIAL)
      if [ "$fb_connected" != "" ]; then
        echo "Device $ANDROID_SERIAL is in fastboot mode"
        return 1
      fi

      local connected=$($ADB_BIN devices | wc -l)
      if [[ $connected -lt 3 ]]; then
        echo "No devices connected!"
        return 1
      fi

      read REPLY\?"Do you want to switch adb devices (y): "
      if [[ "$REPLY" != "n"* ]]; then
        select_android_device || return 1

        $ADB_BIN $@
      fi
    fi
  fi

  return $?
}

function myfastboot()
{
  local external=true

  for i in flash getvar oem flashing erase boot flashall update continue set_active; do
    if [ "$1" == "$i" ]; then
      external=false
      break
    fi
  done

  if $external; then
    $FASTBOOT_BIN $@
    return $?
  fi

  if [ -z "$ANDROID_SERIAL" ]; then
    # Try to find single connected fastboot device
    declare -a devices

    command fastboot devices -l | while read x; do devices+=("$x"); done
    if [[ ${#devices[@]} -eq 1 ]]; then
      local dev=${devices[1]}
      export ANDROID_SERIAL=${dev%% *}
    fi

    # If none found try to find from the list
    [ -n "$ANDROID_SERIAL" ] || select_android_device || return 1
  fi

  LAST_ANDROID_SERIAL=

  #local fb_connected=$($FASTBOOT_BIN devices 2>/dev/null | grep ^$ANDROID_SERIAL)
  #[ -z "$fb_connected" ] && echo "Selected device \"$ANDROID_SERIAL\" currently not in fastboot mode"
  $FASTBOOT_BIN $@
}

function paddedstr()
{
  local len=$1
  shift
  local str=$*

  local npadding=$(expr $len - ${#str})
  local padding
  [ $npadding -gt 0 ] && padding=$(printf '%*s' $npadding ' ') || padding=
  echo "${str}${padding}"
}

function print_android_info()
{
  local pretty=$1
  local aserial=$2
  local dev=$3
  local rev=$4
  local build=$5
  local devrev

  [ -n "$rev" -a "$rev" != "0" ] && devrev="${dev# } (${rev# })" || devrev=${dev}
  if $pretty; then
    echo -n "$(paddedstr 16 $aserial) | "
    [ -z "$build" ] && build="N/A"
    echo -n "$(paddedstr 16 $build) | "
    echo "$(paddedstr 22 $devrev)"
  else
    echo -n ${devrev}
    [ -n "$build" ] && echo -n ":${build# }"
    echo ":${aserial}"
  fi
}

function get_android_adb_var()
{
  local aserial=$1
  local varname=$2
  echo -n $($ADB_BIN -s $aserial shell getprop $varname)
}

function get_android_adb_info()
{
  local aserial=$1
  local pretty=${2:-false}
  [ "$aserial" = "" ] && return 1

  local state=$($ADB_BIN -s $aserial get-state 2>/dev/null)
  [ "$state" != "device" ] && return 1

  local build=$(get_android_adb_var $aserial ro.build.id)
  local dev=$(get_android_adb_var $aserial ro.hardware)
  local rev=$(get_android_adb_var $aserial ro.revision)

  print_android_info $pretty "$aserial" "$dev" "$rev" "$build"

  return 0
}

function get_android_fb_var()
{
  local aserial=$1
  local varname=$2
  local pre=
  [ -z "$(command -v timeout)" ] || pre="timeout 1s"
  local val=$(${=pre} fastboot -s $aserial getvar $varname 2>&1 | grep ^${varname} | sed -E "s/${varname}: //g")
  [ -n "$val" -a "$val" != "unknown variable" ] && [[ "$val" =~ ^[[:alnum:]].* ]] && echo $val
}

function get_android_fb_info()
{
  local aserial=$1
  local pretty=${2:-false}
  [ "$aserial" = "" ] && return 1

  local fb_connected=$($FASTBOOT_BIN devices | grep ^$aserial)
  if [ -n "$fb_connected" ]; then
    local dev=$(get_android_fb_var $aserial product)
    # if no output found now, it's likely going to fail for next ones too
    [ -n "$dev" ] || return 1
    local rev=$(get_android_fb_var $aserial hw-revision)
    local build=$(get_android_fb_var $aserial version-bootloader)

    # reduce ryu (Smaug) bootloader version
    [[ "$build" = "Google_"* ]] && build=${build:7}

    print_android_info $pretty "$aserial" "$dev" "$rev" "$build"

    return 0
  fi

  return 1
}

function get_android_details()
{
  local aserial=${1:-$ANDROID_SERIAL}
  if [ -z "$aserial" ]; then
    return 1
  fi


}

function set_android_prompt_info()
{
  local force=${1:-false}
  if [ -n "$ANDROID_SERIAL" ]; then
    # check if nothing to be done (no changes in serial)
    if ! $force && [ "$ANDROID_SERIAL" = "$LAST_ANDROID_SERIAL" ]; then
      return
    fi

    local aserial=$($ADB_BIN get-serialno 2>/dev/null)

    if [ "$aserial" = "$ANDROID_SERIAL" ]; then
      adb_info=$(get_android_adb_info $ANDROID_SERIAL)
      [ -n "$adb_info" ] && LAST_ANDROID_SERIAL=$ANDROID_SERIAL
    elif [ "$aserial" = "" ]; then
      # try getting info from fastboot
      adb_info=$(get_android_fb_info $ANDROID_SERIAL)
    fi
  else
    adb_info=
  fi
}

function list_android_devices()
{
  declare -a devices

  command adb start-server || ( echo "Unable to start adb"; return 1 )

  local adb_devices=$(command adb devices -l | sed -n "2,100p")
  local fb_devices=$(command fastboot devices -l)
  for dev in ${(f)adb_devices} ${(f)fb_devices}; do
    local aserial=${dev%% *}
    local devinfo=
    local mode=
    if [[ $dev == *"fastboot"* ]]; then
      mode=fastboot
      devinfo=$(get_android_fb_info $aserial true)
    else
      mode=adb
      devinfo=$(get_android_adb_info $aserial true)
    fi
    if [ -n "$devinfo" ]; then
      echo "$devinfo $mode"
    else
      echo "$dev"
    fi
  done
}

function select_android_device_fzf()
{
  local devices=("${(@f)$(list_android_devices)}")
  if [ -z "$devices" ]; then
    echo "No devices connected!"
    return 1
  fi

  local fzf_header="Choose from available connected devices: "
  local fzf_args=(
    --height=$((3+${#devices[@]}))
    --exit-0
    --reverse
    --inline-info
  )
  if [ -n "$1" ]; then
    fzf_args+=(
      --select-1
      --query="$*"
    )
  fi

  local selection=$(echo "${(j:\n:)devices}" | fzf ${fzf_args} --header="${fzf_header}")
  # assumes serial is the first argument
  local aserial=${selection%% *}

  if [ -z "$aserial" ]; then
    if [ -n "$1" ]; then
      echo "No devices matching: \"$@\""
    else
      echo "No device selected"
    fi
    return 1
  fi

  export ANDROID_SERIAL=${aserial}
  local devinfo=$(get_android_adb_info $ANDROID_SERIAL || get_android_fb_info $ANDROID_SERIAL || echo "$ANDROID_SERIAL")
  echo "Selected device: $devinfo"
  set_android_prompt_info true
}

function select_android_device_list()
{
  local devices=("${(@f)$(list_android_devices)}")
  if [ -z "$devices" ]; then
    echo "No devices connected!"
    return 1
  fi

  local counter=0
  local selection=$1
  declare -a serial_list
  if [ -z "$selection" ]; then
    echo "Choose from connected devices"

    for dev in ${devices}; do
      let counter=counter+1
      serial_list[$counter]=${dev%% *}

      echo "${counter}. ${dev}"
    done

    read selection\?"Select option: "
  fi
  echo
  if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
    echo "Invalid option \"$selection\". Should be numeric"
    return 1
  elif [ "${serial_list[$selection]}" = "" ]; then
    echo "Invalid option \"$selection\""
    return 1
  fi

  export ANDROID_SERIAL=${serial_list[$selection]}
  local devinfo=$(get_android_adb_info $ANDROID_SERIAL || get_android_fb_info $ANDROID_SERIAL || echo "$ANDROID_SERIAL")
  echo "Selected device #${selection}: $devinfo"
  set_android_prompt_info true

  return 0
}

function select_android_device()
{
  if [ -n "$(command -v fzf)" ]; then
    select_android_device_fzf $@
  else
    select_android_device_list $@
  fi
}

function get_partition_img() {
  local default_ext=img
  local filename=$1

  partition=${filename:t:r}

  if [ -f $filename ]; then
    echo $partition $filename
    return 0
  fi

  # try to find it within env folders
  for d in $PWD $ANDROID_PRODUCT_OUT $OUT; do
    local full_filename=${d}/${filename}

    if [ -d "${d}" ]; then
      if [ -f "$full_filename" ]; then
        echo $partition $full_filename
        return 0
      else
        for ext in img mbn; do
          if [ -f "${full_filename}.${ext}" ]; then
            echo $partition ${full_filename}.${ext}
            return 0
          fi
        done
      fi
    fi
  done
  echo $partition $filename
}

function flash_partitions() {
  for p in $@; do
    local pimg=$(get_partition_img $p)
    local partition=${${(z)pimg}[1]}
    local img=${${(z)pimg}[2]}
    if [ -f "$img" ]; then
      if [ "$partition" == "persist" ]; then
        print -nP "%F{red}Are you sure you want to flash %B%F{magenta}${partition}%b%F{red} partition???%f "
        read reply
        if [ "$reply" != "y" ]; then
          continue
        fi
      fi

      print -P "%F{green}Flashing %B%F{magenta}${partition}%b%F{green} partition...%f"
      fastboot flash $partition $img
    else
      print -P "%F{yellow}Unable to find %B%F{magenta}${partition}%b%F{yellow} partition image!%f"
    fi
  done
}

function fbb() {
  local pimg=$(get_partition_img ${1:-boot.img})
  local img=${${(z)pimg}[2]}

  if [ -f "$img" ]; then
    echo "Found image: $img"
  else
    KERNEL_IMG_OPTS=(
      Image.lz4-dtb
      Image.gz-dtb
      Image.fit
      zImage-dtb
      bzImage
    )
    KERNEL_PATH_OPTS=($PWD $DIST_DIR $COMMON_OUT_DIR/dist)
    img=
    for p in $KERNEL_PATH_OPTS; do
      [ -d "$p" ] || continue
      for k in $KERNEL_IMG_OPTS; do
        if [ -f "$p/$k" ]; then
          img=$p/$k
          echo "Found $k at $p"
          break;
        fi
      done
      [ -z "$img" ] || break
    done
    # last resort set kernel env to see if we can find image
    if [ ! -f "$img" ]; then
      local dist_dir=$(kenv 1>/dev/null 2>/dev/null && echo $DIST_DIR)
      for k in $KERNEL_IMG_OPTS; do
        if [ -f "$dist_dir/$k" ]; then
          img=$dist_dir/$k
          echo "Found $k through kernel environment"
          break;
        fi
      done
    fi
  fi
  if [ -f "$img" ]; then
    print -P "Kernel image: $(realpath --relative-to=$PWD $img)\n"
    print -P "%F{green}Booting with %B%F{magenta}$(basename ${img})%b%F{green}...%f"
    fastboot boot $img
  else
    print -P "%F{yellow}Unable to find kernel image%f"
  fi
}

function lc()
{
  adb logcat -v threadtime | logcat-color --no-wrap
}

alias arb="adb reboot bootloader"
alias arr="adb reboot recovery"
alias adbw="adb wait-for-device"
alias adbs="adb wait-for-device shell"

alias fb="fastboot"
alias fbr="fastboot reboot"
alias frb="fastboot reboot bootloader"
alias fbc="fastboot continue"
alias ff="flash_partitions"
alias fff="flash_partitions boot dtbo vendor system vbmeta product"
alias ffb="ff boot dtbo"
alias ffs="ff system"
alias ffv="ff vendor product"
alias sad="select_android_device"
alias ad="list_android_devices"
alias adb="myadb"
alias fastboot="myfastboot"
