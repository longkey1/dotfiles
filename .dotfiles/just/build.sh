#!/usr/bin/env zsh

BINARY="just"
REPOSITORY="casey/just"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi
