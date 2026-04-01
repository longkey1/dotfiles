#!/usr/bin/env zsh

GO_INSTALL_DIR="${HOME}/.local/go"

for binary in go gofmt; do
  if [ -e "${REMOTE_BIN}/${binary}" ]; then
    echo "${REMOTE_BIN}/${binary} already exists"
  else
    ln -s "${GO_INSTALL_DIR}/bin/${binary}" "${REMOTE_BIN}/${binary}" && echo "${REMOTE_BIN}/${binary} linked"
  fi
done
