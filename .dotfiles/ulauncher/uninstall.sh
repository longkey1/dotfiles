#!/usr/bin/env zsh

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" != "linux" ]; then
  exit
fi

. ${DOTFILES}/functions

unsymlink config/ulauncher
