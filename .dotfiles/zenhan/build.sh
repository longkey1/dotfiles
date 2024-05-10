#!/usr/bin/env zsh

DIRECTORY="zenhan"
REPOSITORY="iuchim/zenhan"
CURRENT=$(cd $(dirname $0);pwd)
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files"

if [[ "$(uname -r)" != *microsoft* ]]; then
  exit 0
fi

if [ ! -d "${WIN_BIN}/${DIRECTORY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --file zenhan --to ${WIN_BIN}/
fi
