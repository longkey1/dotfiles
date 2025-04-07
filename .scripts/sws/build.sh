#!/usr/bin/env zsh

BINARY="sws"
REPOSITORY="joseluisq/static-web-server"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" = "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/sws --asset linux-musl.tar.gz
  else
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/sws
  fi
fi
