#!/usr/bin/env bash

. "${SCRIPTS}"/functions

for binary in go gofmt; do
  if [ ! -h "${ROOT}/local/bin/${binary}" ]; then
    ln -s "../go/bin/${binary}" "${ROOT}/local/bin/${binary}"
  fi
  symlink_to_symlink local/bin/${binary}
done
