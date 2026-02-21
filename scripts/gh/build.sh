#!/usr/bin/env zsh

REPOSITORY="cli/cli"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/gh --upgrade-only --asset tar.gz
elif [ "${OS}" = "darwin" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/gh --upgrade-only
fi
