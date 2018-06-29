#!/bin/bash

my_path=${${(%):-%N}:A:h}
fpath=($fpath $my_path)

autoload -Uz select_android_device

alias sad="select_android_device"
alias ad="select_android_device -l"
