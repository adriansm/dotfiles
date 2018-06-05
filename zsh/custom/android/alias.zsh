#!/bin/sh

### quick android shortcuts

alias deqp="adb -d shell am start -n com.drawelements.deqp/android.app.NativeActivity -e cmdLine"

function buc() {
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

function ggrep()
{
  find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.gradle" \
    -exec grep --color -n "$@" {} +
}

function jgrep()
{
  find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.java" \
    -exec grep --color -n "$@" {} +
}

function cgrep()
{
  find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) \
    -exec grep --color -n "$@" {} +
}

function resgrep()
{
  for dir in `find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -name res -type d`; do
    find $dir -type f -name '*\.xml' -exec grep --color -n "$@" {} +
  done
}

function mangrep()
{
  find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -type f -name 'AndroidManifest.xml' \
    -exec grep --color -n "$@" {} +
}

function sepgrep()
{
  find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -name sepolicy -type d \
    -exec grep --color -n -r --exclude-dir=\.git "$@" {} +
}

function rcgrep()
{
  find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.rc*" \
    -exec grep --color -n "$@" {} +
}

