#!/usr/bin/env zsh

BINARY="zenhan.exe"
REPOSITORY="iuchim/zenhan"
CURRENT=$(cd $(dirname $0);pwd)
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files/zenhan"

if [[ "$(uname -r)" != *microsoft* ]]; then
  exit 0
fi

if [ ! -x "${WIN_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${WIN_BIN}/${BINARY}
fi
