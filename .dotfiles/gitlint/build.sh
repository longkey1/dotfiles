#!/usr/bin/env zsh

BINARY="gitlint"
REPOSITORY="llorllale/go-gitlint"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH="amd64"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --system ${OS}/${ARCH} --file ${BINARY} --to ${LOCAL_BIN}/
fi
