#!/usr/bin/env zsh

BINARY="envsubstj"
REPOSITORY="a8m/envsubst"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset ^.md5
fi
