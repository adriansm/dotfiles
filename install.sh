#!/bin/sh

export BINDIR=$HOME/.local/bin

sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply adriansm --branch chezmoi && \
  echo "Succesfully installed Adrian's dotfiles"
