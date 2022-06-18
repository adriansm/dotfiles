#!/bin/bash

trap 'exit 0' TERM INT
trap "kill %%" EXIT

secure_dimmer=/usr/lib/x86_64-linux-gnu/xsecurelock/dimmer
alt_dimmer=/usr/share/doc/xss-lock/dim-screen.sh
if [ -x $dimmer ]; then
    >&2 echo "Running xsecurelock dimmer"
    exec $secure_dimmer -l $@ &
    >&2 echo "Finished dimmer"
elif [ -x $alt_dimmer ]; then
    >&2 echo "Running xss-lock dimmer"
    exec $alt_dimmer $@ &
else
    >&2 echo "No dimmer available"
fi

sleep 2147483647 &
wait
