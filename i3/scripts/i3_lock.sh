#!/bin/bash

ALLOW_XSECURELOCK=${ALLOW_XSECURELOCK:-1}
XSECURELOCK_BIN=/usr/share/goobuntu-desktop-files/xsecurelock.sh
if [ $ALLOW_XSECURELOCK != 0 -a -f $XSECURELOCK_BIN ]; then
    export XSECURELOCK_SAVER=$HOME/.local/bin/saver_img

    # Media Keys
    export XSECURELOCK_KEY_XF86AudioPlay_COMMAND="playerctl play-pause"
    export XSECURELOCK_KEY_XF86AudioNext_COMMAND="playerctl next"
    export XSECURELOCK_KEY_XF86AudioPrev_COMMAND="playerctl previous"
    export XSECURELOCK_KEY_XF86AudioRaiseVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ +5%"
    export XSECURELOCK_KEY_XF86AudioLowerVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ -5%"
    export XSECURELOCK_KEY_XF86AudioMute_COMMAND="pactl set-sink-mute @DEFAULT_SINK@ toggle"

    . $XSECURELOCK_BIN $@
else
    i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts $@
fi
