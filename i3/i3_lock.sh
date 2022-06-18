#!/bin/sh

. /etc/lsb-release
GLOCK=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ -f $GLOCK -a "$GOOGLE_ROLE" != "laptop"]; then
    export XSECURELOCK_SAVER=$HOME/.local/bin/saver_img

    $GLOCK $@
else
    i3lock -c 333333 $@
fi
