#!/usr/bin/env zsh

REPOSITORY="mikefarah/yq"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed s/x86_64/amd64/)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/yq --asset ${OS}_${ARCH}.tar.gz --file yq_${OS}_${ARCH} --upgrade-only
