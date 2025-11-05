#!/usr/bin/env zsh

BINARY="gitlint"
REPOSITORY="llorllale/go-gitlint"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH="amd64"

${LOCAL_BIN}/eget ${REPOSITORY} --system ${OS}/${ARCH} --file ${BINARY} --to ${LOCAL_BIN}/gitlint --upgrade-only
