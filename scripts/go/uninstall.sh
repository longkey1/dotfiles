#!/usr/bin/env bash

. "${SCRIPTS}"/functions

for binary in go gofmt; do
  unsymlink local/bin/${binary}
  if [ -h "${ROOT}/local/bin/${binary}" ]; then
    unlink "${ROOT}/local/bin/${binary}"
  fi
done

if [ -h "${HOME}/.local/go" ]; then
  unlink "${HOME}/.local/go" && echo "${HOME}/.local/go unlinked"
fi
