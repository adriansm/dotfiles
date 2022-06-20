# avoid conflicting with build env adb
[ -z $ADB_BIN ] && ADB_BIN=$(which adb)
[ -z $FASTBOOT_BIN ] && FASTBOOT_BIN=$(which fastboot)

#export ANDROID_ADB_SERVER_PORT=5050
unset ANDROID_SERIAL
export LAST_ANDROID_SERIAL=
export adb_info=

# to speed up builds
export USE_CCACHE=1

ADB_EXCLUSION_KEYWORDS="
  -s
  devices
  help
  start-server
  kill-server
  connect
  disconnect
"

FASTBOOT_EXCLUSION_KEYWORDS="
  -s
  devices
  help
"

function switch_adb_bin()
{
  if [ -z "$1" ]; then
    echo "Use: $0 <adb_path> [port]"
    return 1
  fi

  local adb_path=$1
  if [ ! -x "$adb_path" ]; then
    echo "Invalid adb binary provided: $adb_path"
    return 1
  fi
  export ADB_BIN=$adb_path

  if [ -n "$2" ]; then
    local adb_port=$2
    if ! [[ "$adb_port " =~ ^[0-9]+$ ]]; then
      echo "Invalid port number provided: $adb_port"
      return 1
    elif [ $adb_port -gt 65535 ]; then
      echo "Port number should be <= 65535"
      return 1
    fi
    export ANDROID_ADB_SERVER_PORT=$adb_port
  fi
}

function select_android_adb()
{
  echo "TBD: dynamicall select adb version"
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
    echo -n "$(paddedstr 16 $devrev) | "
    [ -z "$build" ] && build="N/A"
    echo -n "$(paddedstr 16 $build) | "
    echo "$(paddedstr 16 $aserial)"
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
  [ "$aserial" == "" ] && return 1

  local state=$($ADB_BIN -s $aserial get-state 2>/dev/null)
  [ "$state" != "device" ] && return 1

  local build=$(get_android_adb_var $aserial ro.build.id)
  local dev=$(get_android_adb_var $aserial ro.build.product)
  local rev=$(get_android_adb_var $aserial ro.revision)

  print_android_info $pretty "$aserial" "$dev" "$rev" "$build"

  return 0
}

function get_android_fb_var()
{
  local aserial=$1
  local varname=$2

  local val=$(fastboot -s $aserial getvar $varname 2>&1 | grep ^${varname}| sed -E "s/${varname}: //g")
  [ -n "$val" -a "$val" != "unknown variable" ] && [[ "$val" =~ ^[[:alnum:]].* ]] && echo $val
}

function get_android_fb_info()
{
  local aserial=$1
  local pretty=${2:-false}
  [ "$aserial" == "" ] && return 1

  local fb_connected=$($FASTBOOT_BIN devices | grep ^$aserial)
  if [ "$fb_connected" != "" ]; then
    local dev=$(get_android_fb_var $aserial product)
    local rev=$(get_android_fb_var $aserial hw-revision)
    local build=$(get_android_fb_var $aserial version-bootloader)

    # reduce ryu (Smaug) bootloader version
    [[ "$build" == "Google_"* ]] && build=${build:7}

    print_android_info $pretty "$aserial" "$dev" "$rev" "$build"

    return 0
  fi

  return 1
}

function set_android_prompt_info()
{
  local force=${1:-false}
  if [ -n "$ANDROID_SERIAL" ]; then
    # check if nothing to be done (no changes in serial)
    if ! $force && [ "$ANDROID_SERIAL" == "$LAST_ANDROID_SERIAL" ]; then
      return
    fi

    local aserial=$($ADB_BIN get-serialno 2>/dev/null)

    if [ "$aserial" == "$ANDROID_SERIAL" ]; then
      adb_info=$(get_android_adb_info $ANDROID_SERIAL)
      [ -n "$adb_info" ] && LAST_ANDROID_SERIAL=$ANDROID_SERIAL
    elif [ "$aserial" == "" ]; then
      # try getting info from fastboot
      adb_info=$(get_android_fb_info $ANDROID_SERIAL)
    fi
  else
    adb_info=
  fi
}

function select_android_device()
{
    local counter=0
    local selection=$1
    declare -a devices

    $ADB_BIN start-server || ( echo "Unable to start adb"; return 1 )

    # mapfile only works on bash 4
    if [ ${BASH_VERSION%%.*} -lt 4 ]; then
        IFS=$'\r\n' GLOBIGNORE='*' command eval 'devices=($(${ADB_BIN} devices -l | sed -n "2,100p"))'
        IFS=$'\r\n' GLOBIGNORE='*' command eval 'fbdevices=($(${FASTBOOT_BIN} devices -l))'
        devices+=( "${fbdevices[@]}" )
    else
        mapfile -s 1 -t devices < <(${ADB_BIN} devices -l | head -n -1)
        mapfile -O ${#devices[@]} -t devices < <(${FASTBOOT_BIN} devices -l)
    fi


    if [ ${#devices[@]} -eq 0 ]; then
      #echo "error: No devices are connected"
      return 1
    fi

    if [ -z "$selection" ]; then
      echo "Choose from connected devices"
      for d in "${devices[@]}"; do
        let counter=counter+1
        local aserial=$(echo $d | { read first _; echo $first; } )

        local devinfo=
        local mode=unknown
        if [[ $d == *"fastboot"* ]]; then
          mode=fastboot
          devinfo=$(get_android_fb_info $aserial true)
        else
          mode=adb
          devinfo=$(get_android_adb_info $aserial true)
        fi

        if [ -n "$devinfo" ]; then
          echo "${counter}. ${devinfo} ${mode}"
        else
          echo "${counter}. ${d}"
        fi
      done

      read -p "Select option: " selection
    fi
    if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
      echo "Invalid option. Should be numeric" $selection
      return 1
    fi
    echo

    let selected_device=selection-1
    if [ "${devices[$selected_device]}" == "" ]; then
      echo "Invalid option \"$selection\""
      return 1
    fi

    export ANDROID_SERIAL=$(echo ${devices[$selected_device]} | { read first _; echo $first; } )
    devinfo=$(get_android_adb_info $ANDROID_SERIAL || get_android_fb_info $ANDROID_SERIAL || echo "$ANDROID_SERIAL")
    echo "Selected device #${selection}: $devinfo"
    echo
    set_android_prompt_info true

    return 0
}

function sad()
{
  select_android_device $@
}

function madb()
{
  local args=" $* "

  for e in $ADB_EXCLUSION_KEYWORDS; do
    if [ "$args" != "${args/ $e /}" ]; then
      $ADB_BIN $@
      return $?
    fi
  done

  if [ "$ANDROID_SERIAL" == "" ]; then
    $ADB_BIN start-server || ( echo "Unable to start adb"; return 1 )

    # Try to find connected adb device
    export ANDROID_SERIAL=$(${ADB_BIN} get-serialno 2>/dev/null)
    [ "$ANDROID_SERIAL" != "" ] || select_android_device || return 1
  fi

  set_android_prompt_info
  $ADB_BIN $@

  if [ "$?" != "0" ]; then
    local connected=$($ADB_BIN get-state 2>/dev/null)
    if [ "$connected" == "" ]; then
      #echo "Trying to find if $ANDROID_SERIAL is connected"
      local fb_connected=$($FASTBOOT_BIN devices | grep ^$ANDROID_SERIAL)
      if [ "$fb_connected" != "" ]; then
        echo "Device $ANDROID_SERIAL is in fastboot mode"
        return 1
      fi

      local connected=$($ADB_BIN devices | wc -l)
      if [ $connected -lt 3 ]; then
        echo "No devices connected!"
        return 1
      fi

      read -p "Do you want to switch adb device (y)? "
      if [ "$REPLY,," != "n" ]; then
        select_android_device || return 1

        $ADB_BIN $@
      fi
    fi
  fi

  return $?
}

function fastboot()
{
  local args=" $* "

  for e in $FASTBOOT_EXCLUSION_KEYWORDS; do
    if [ "$args" != "${args/ $e /}" ]; then
      $FASTBOOT_BIN $@
      return $?
    fi
  done

  if [ "$ANDROID_SERIAL" == "" ]; then
    # Try to find single connected fastboot device
    declare -a devices

    # mapfile only works on bash 4
    if [ ${BASH_VERSION%%.*} -lt 4 ]; then
        IFS=$'\r\n' GLOBIGNORE='*' command eval 'devices=($(${FASTBOOT_BIN} devices -l))'
    else
        mapfile -t devices < <(${FASTBOOT_BIN} devices)
    fi
    [ ${#devices[@]} -eq 1 ] && export ANDROID_SERIAL=$(echo ${devices[0]} | { read first _; echo $first; } )

    # If none found try to find from the list
    [ "$ANDROID_SERIAL" != "" ] || select_android_device || return 1
  fi

  LAST_ANDROID_SERIAL=

  #local fb_connected=$($FASTBOOT_BIN devices 2>/dev/null | grep ^$ANDROID_SERIAL)
  #[ "$fb_connected" == "" ] && echo "Selected device \"$ANDROID_SERIAL\" currently not in fastboot mode"
  $FASTBOOT_BIN $@
}

