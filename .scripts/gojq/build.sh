#!/usr/bin/env zsh

BINARY="gojq"
REPOSITORY="itchyny/gojq"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
