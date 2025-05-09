#!/usr/bin/env zsh

BINARY="bat"
REPOSITORY="sharkdp/bat"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" = "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset linux-musl
  else
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
  fi
fi
