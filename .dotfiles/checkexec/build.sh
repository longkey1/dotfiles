#!/usr/bin/env zsh

BINARY="checkexec"
REPOSITORY="kurtbuilds/checkexec"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${BIN}/eget ${REPOSITORY} --to ${BIN}/
