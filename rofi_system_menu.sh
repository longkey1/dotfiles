#!/usr/bin/env bash

set -euCo pipefail

list=(
  ##  Lock  ##
  "Logout"       "gnome-session-quit --force"
  "Shutdown"     "systemctl poweroff"
)

if selected="$(for (( i=0; i<=$((${#list[@]}/2-1)); i++ )) { echo "${list[($i+1)*2-2]}"; } | rofi -dmenu -i -format i)"; then
k
