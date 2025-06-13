#!/usr/bin/env zsh

BINARY="gojq"
REPOSITORY="itchyny/gojq"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

if [ ! -e ${LOCAL_BIN}/jq ]; then
  ln ${LOCAL_BIN}/gojq ${LOCAL_BIN}/jq
fi
