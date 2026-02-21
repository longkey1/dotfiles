#!/usr/bin/env zsh

REPOSITORY="a8m/envsubst"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset ^.md5
