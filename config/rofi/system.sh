#!/usr/bin/env bash

set -euCo pipefail

function main() {
  local -Ar menu=(
    ['Logout']='cinnamon-session-quit --no-prompt'
    ['Poweroff']='systemctl poweroff'
    ['Reboot']='systemctl reboot'
  )

  local -r IFS=$'\n'
  [[ $# -ne 0 ]] && eval "${menu[$1]}" || echo "${!menu[*]}"
}

main $@
