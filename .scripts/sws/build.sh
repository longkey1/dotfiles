#!/usr/bin/env zsh

REPOSITORY="joseluisq/static-web-server"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/sws --upgrade-only --asset linux-musl.tar.gz
else
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/sws --upgrade-only
fi
