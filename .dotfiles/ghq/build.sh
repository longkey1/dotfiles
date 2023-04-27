#!/usr/bin/env zsh

BINARY="ghq"
REPOSITORY="x-motemen/ghq"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
