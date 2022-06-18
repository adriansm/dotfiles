#!/bin/bash

MY_DIR=$(dirname $0)
SCRIPT_NAME="i3-autoname-workspaces.py"

kill_script() {
    local pid=$(ps -C python3 -o pid=,args= | grep i3-auto | cut -d' ' -f2)
    if [ -n "$pid" ]; then
        >&2 echo "Killing previous instance of $SCRIPT_NAME ($pid)"
        kill $pid
    fi
}

run_script() {
    $MY_DIR/$SCRIPT_NAME
}

if [ "$1" == "--force" ]; then
    kill_script
fi

while true; do
    run_script && break

    echo "$SCRIPT_NAME died unexpectedly, restarting"
done
