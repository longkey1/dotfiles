#!/usr/bin/env zsh

if [[ "$(uname -r)" != *microsoft* ]]; then
  exit 0
fi

DIRECTORY="zenhan"
REPOSITORY="iuchim/zenhan"
CURRENT=$(cd $(dirname $0);pwd)
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files"

${LOCAL_BIN}/eget ${REPOSITORY} --file zenhan --to ${WIN_BIN}/ --upgrade-only
