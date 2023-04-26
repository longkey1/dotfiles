#!/usr/bin/env zsh

BINARY="yq"
REPOSITORY="mikefarah/yq"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed s/x86_64/amd64/)

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/yq --asset ${OS}_${ARCH}.tar.gz --file yq_${OS}_${ARCH}
