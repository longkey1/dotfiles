#!/usr/bin/env zsh

REPOSITORY="xo/usql"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/usql --upgrade-only --asset static --file usql_static
else
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/usql --upgrade-only
fi
