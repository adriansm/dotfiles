#!/bin/bash

BAUD_RATE=115200
DEBUG=false

function pr_err() { echo $@ 1>&2; }
function pr_debug() { $DEBUG && echo $@ 1>&2; }

function choose_serial()
{
    declare -a devices
    if [[ "$OSTYPE" == *"darwin"* ]]; then
        SERIAL_DEVICES=/dev/tty.usbserial-*
    else
        SERIAL_DEVICES=/dev/ttyUSB*
    fi
    for d in $SERIAL_DEVICES; do
        pr_debug "Checking $d"
        [ -r "$d" ] && devices+=($d)
    done

    #IFS=$'\r\n' GLOBIGNORE='*' command eval 'devices=($SERIAL_OPTIONS)'
    if [ ${#devices[@]} -eq 0 ]; then
        pr_err "No serial devices found"
        exit 1
    elif [ ${#devices[@]} -eq 1 ]; then
        SERIAL_DEV=${devices[0]}
    else
        local counter=0
        pr_err "Multiple serial devices please choose one:"
        for d in "${devices[@]}"; do
            let counter+=1
            pr_err "${counter}. $d"
        done
        read -p "Select option: " selection
        if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
            pr_err "Invalid option '$selection'. Should be numeric"
            return 1
        fi
        pr_err
        let selected_device=selection-1
        pr_debug "Selection: $selection"
        SERIAL_DEV=${devices[$selected_device]}
        if [ -z "$SERIAL_DEV" ]; then
            pr_err "Invalid option '$selection'"
            return 1;
        fi
    fi
    echo $SERIAL_DEV $BAUD_RATE

    return 0
}

SERIAL_DEVICE=$(choose_serial)
echo "Connecting to $SERIAL_DEVICE"
[ -n "$SERIAL_DEVICE" ] && screen $SERIAL_DEVICE $BAUD_RATE

