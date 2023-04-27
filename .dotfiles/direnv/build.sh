#!/usr/bin/env zsh

BINARY="direnv"
REPOSITORY="direnv/direnv"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
