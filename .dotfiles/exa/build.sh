#!/usr/bin/env zsh

BINARY="exa"
REPOSITORY="ogham/exa"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" = "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset linux-x86_64-musl
  else
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
  fi
fi
