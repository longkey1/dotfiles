#!/usr/bin/env zsh

BINARY="xh"
REPOSITORY="ducaale/xh"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH="amd64"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --system ${OS}/${ARCH} --to ${LOCAL_BIN}/
fi
