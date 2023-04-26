#!/usr/bin/env zsh

BINARY="rg"
REPOSITORY="BurntSushi/ripgrep"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
