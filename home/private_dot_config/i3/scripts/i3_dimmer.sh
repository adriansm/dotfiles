#!/bin/bash

mydir=$(dirname $0)

export LOCKED_BY_SESSION_IDLE=true
$mydir/i3_lock.sh
