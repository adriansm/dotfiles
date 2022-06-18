#!/bin/bash

ALLOW_XSECURELOCK=1
XSECURELOCK_BIN=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ $ALLOW_XSECURELOCK != 0 -a -f $XSECURELOCK_BIN ]; then
    export XSECURELOCK_SAVER=$HOME/.local/bin/saver_img
    . $XSECURELOCK_BIN $@
else
    i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts $@
fi
