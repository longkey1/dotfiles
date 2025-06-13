#!/usr/bin/env zsh

REPOSITORY="cli/cli"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed s/x86_64/amd64/)

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset ${OS}_${ARCH}.tar.gz
elif [ "${OS}" = "darwin" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
fi
