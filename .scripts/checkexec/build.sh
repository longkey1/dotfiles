#!/usr/bin/env zsh

BINARY="checkexec"
REPOSITORY="kurtbuilds/checkexec"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi
