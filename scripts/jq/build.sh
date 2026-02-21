#!/usr/bin/env zsh

BINARY="jq"
REPOSITORY="itchyny/gojq"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/${BINARY} --upgrade-only
