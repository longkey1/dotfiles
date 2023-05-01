#!/usr/bin/env zsh

BINARY="lf"
REPOSITORY="gokcehan/lf"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi
