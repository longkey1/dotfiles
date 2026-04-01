#!/usr/bin/env zsh

for binary in go gofmt; do
  if [ -h "${REMOTE_BIN}/${binary}" ]; then
    unlink "${REMOTE_BIN}/${binary}" && echo "${REMOTE_BIN}/${binary} unlinked"
  elif [ -e "${REMOTE_BIN}/${binary}" ]; then
    echo "${REMOTE_BIN}/${binary} not unlinked, not a symlink"
  else
    echo "${REMOTE_BIN}/${binary} no exists"
  fi
done
