#!/usr/bin/env zsh

BINARY="usql"
REPOSITORY="xo/usql"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" == "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/usql --asset static --file usql_static
  else
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/usql
  fi
fi
