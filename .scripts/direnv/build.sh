#!/usr/bin/env zsh

BINARY="direnv"
REPOSITORY="direnv/direnv"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi
