#!/bin/bash

ALLOW_XSECURELOCK=${ALLOW_XSECURELOCK:-1}
XSECURELOCK_BIN=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ $ALLOW_XSECURELOCK != 0 -a -f $XSECURELOCK_BIN ]; then
    export XSECURELOCK_SINGLE_AUTH_WINDOW=1
    export XSECURELOCK_SAVER=$HOME/.local/bin/saver_img
    export XSECURELOCK_COMPOSITE_OBSCURER=0
    # export XSECURELOCK_DIM_TIME_MS=3000
    # export XSECURELOCK_WAIT_TIME_MS=10000

    # Media Keys
    export XSECURELOCK_KEY_XF86AudioPlay_COMMAND="playerctl play-pause"
    export XSECURELOCK_KEY_XF86AudioNext_COMMAND="playerctl next"
    export XSECURELOCK_KEY_XF86AudioPrev_COMMAND="playerctl previous"
    export XSECURELOCK_KEY_XF86AudioRaiseVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ +5%"
    export XSECURELOCK_KEY_XF86AudioLowerVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ -5%"
    export XSECURELOCK_KEY_XF86AudioMute_COMMAND="pactl set-sink-mute @DEFAULT_SINK@ toggle"

    # Pause media before locking
    playerctl pause

    . $XSECURELOCK_BIN $@

    # if [ -n "$XSECURE_RUN_AFTER" -a -x "$XSECURELOCK_RUN_AFTER" ]; then
    #     $XSECURELOCK_RUN_AFTER
    # fi
    xrefresh
else
    i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts $@
fi
