#!/usr/bin/env zsh

REPOSITORY="cli/cli"

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset tar.gz
elif [ "${OS}" = "darwin" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
fi
