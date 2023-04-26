#!/usr/bin/env zsh

BINARY="gojq"
REPOSITORY="itchyny/gojq"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
[ ! -e ${LOCAL_BIN}/jq ] && ln ${LOCAL_BIN)}gojq ${LOCAL_BIN}/jq || true
