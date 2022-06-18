#!/bin/bash

#logger -t "Current display=$DISPLAY XAUTHORITY=$XAUTHORITY"
#export DISPLAY=:0
#export XAUTHORITY=/home/salidoa/.Xauthority

# Get out of town if something errors
set +e

function check_xrandr_status() {
    local monitor=$1
    if xrandr --listactivemonitors | grep -e "\b${monitor}\b" > /dev/null; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

function wait_for_monitor() {
    local monitor=$1

    # timeout in 3 secs
    for i in $(seq 1 30); do
        local status=$(check_xrandr_status $monitor)
        [ "$status" = "connected" ] && return 0
        logger -t "waiting for 100ms"
    done
    return 1
}

function drm_status() {
    local label=$1
    local drm_file=/sys/class/drm/card0-${label}/status
    [ -r $drm_file ] && cat $drm_file
}

function check_external_status() {
    local monitor=$1
    local drm_file=/sys/class/drm/card0-${monitor}/status

    drm_status $monitor && return 0
    # Check if name has dash and try without (ex. DP-1)
    alt_name=${monitor/-/}
    [ "$monitor" != "${alt_name}" ] && drm_status $alt_name && return

    # Otherwise if it didn't try to add it (ex. DP1)
    alt_name=$(echo $monitor | sed 's/\([A-Z]\+\)\([0-9]\+\)/\1*-\2/')
    [ "$monitor" != "${alt_name}" ] && drm_status $alt_name && return

    echo "unknown"
}

function check_monitors() {
    local monitor=$1
    while read monitor; do
        local status=$(check_external_status $monitor)
        echo "Monitor $monitor status: $status"
        if [ "$status" = "connected" ]; then
            echo "Monitor ${monitor}, seems connected let's wait a bit"
            wait_for_monitor $monitor
        fi
    done < <(xrandr | grep "\bdisconnected\b" | cut -f 1 -d " ")
}

function traverse_monitors() {
    local prev=
    local args=""
    while read monitor; do
        echo "Found monitor: $monitor"
        [ -z "$prev" ] || args="$args --output $monitor --right-of $prev"
        args+=" --auto"
        prev=$monitor
    done < <(xrandr | grep "\bconnected\b" | cut -f 1 -d " ")

    echo "Final args: $args"
    test -z "$args" || xrandr $args
}

check_monitors
traverse_monitors
#pulseaudio --kill && pulseaudio --start
