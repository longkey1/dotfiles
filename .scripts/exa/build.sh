#!/usr/bin/env zsh

REPOSITORY="ogham/exa"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset linux-x86_64-musl
else
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
fi
