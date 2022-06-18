#!/bin/sh

. /etc/lsb-release
GLOCK=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ -f $GLOCK ]; then
    export XSECURELOCK_SAVER=$HOME/.local/bin/saver_img

    $GLOCK $@
else
    i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts $@
fi
