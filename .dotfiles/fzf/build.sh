#!/usr/bin/env zsh

BINARY="fzf"
REPOSITORY="junegunn/fzf"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

