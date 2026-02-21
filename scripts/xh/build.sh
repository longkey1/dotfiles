#!/usr/bin/env zsh

REPOSITORY="ducaale/xh"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH="amd64"

${LOCAL_BIN}/eget ${REPOSITORY} --system ${OS}/${ARCH} --to ${LOCAL_BIN}/ --upgrade-only
