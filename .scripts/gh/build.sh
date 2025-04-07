#!/usr/bin/env zsh

BINARY="gh"
REPOSITORY="cli/cli"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed s/x86_64/amd64/)

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" = "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset ${OS}_${ARCH}.tar.gz
  elif [ "${OS}" = "darwin" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
  fi
fi
