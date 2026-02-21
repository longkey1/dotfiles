#!/usr/bin/env zsh

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" != "linux" ]; then
  exit
fi

. ${SCRIPTS}/functions

unsymlink config/systemd
