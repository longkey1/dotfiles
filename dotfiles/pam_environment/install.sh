#!/usr/bin/env zsh

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" != "linux" ]; then
  exit
fi

. ${ROOT}/dotfiles/functions

symlink pam_environment