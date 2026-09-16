#!/usr/bin/env bash

REPOSITORY="ducaale/xh"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "${ARCH}" = "x86_64" ]; then
  ARCH="amd64"
elif [ "${ARCH}" = "aarch64" ]; then
  ARCH="arm64"
fi

"${LOCAL_BIN}"/eget ${REPOSITORY} --system "${OS}"/${ARCH} --to "${LOCAL_BIN}"/ --upgrade-only
