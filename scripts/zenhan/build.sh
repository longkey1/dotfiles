#!/usr/bin/env bash

if [[ "$(uname -r)" != *microsoft* ]]; then
  exit 0
fi

REPOSITORY="iuchim/zenhan"
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files Local"

"${LOCAL_BIN}"/eget ${REPOSITORY} --file zenhan --to "${WIN_BIN}"/ --upgrade-only
