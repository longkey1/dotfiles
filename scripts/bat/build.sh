#!/usr/bin/env zsh

REPOSITORY="sharkdp/bat"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset linux-musl
else
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
fi
