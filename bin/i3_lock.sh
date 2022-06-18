#!/bin/sh

GLOCK=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ -f $GLOCK ]; then
    $GLOCK $@
else
    i3lock $@
fi
