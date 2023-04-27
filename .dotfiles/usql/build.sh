#!/usr/bin/env zsh

BINARY="usql"
REPOSITORY="xo/usql"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

if [ "${OS}" == "linux" ]; then
  ${BIN}/eget ${REPOSITORY} --to ${BIN}/usql --asset static --file usql_static
else
  ${BIN}/eget ${REPOSITORY} --to ${BIN}/usql
fi
