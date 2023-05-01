#!/usr/bin/env zsh

BINARY="gojq"
REPOSITORY="itchyny/gojq"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

[ ! -e ${LOCAL_BIN}/jq ] && ln ${LOCAL_BIN)}gojq ${LOCAL_BIN}/jq || true
