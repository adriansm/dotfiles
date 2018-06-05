#!/bin/zsh

INTEGRATION_SCRIPT=${0:h}/iterm2_shell_integration.zsh

if ${0:h}/isiterm2.sh && test -e $INTEGRATION_SCRIPT; then
  source $INTEGRATION_SCRIPT
fi

