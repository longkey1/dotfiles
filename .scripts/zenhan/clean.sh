#!/usr/bin/env zsh

if [[ "$(uname -r)" != *microsoft* ]]; then
  exit 0
fi

DIRECTORY="zenhan"
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files/${DIRECTORY}"

rm -rf ${WIN_BIN}
