#!/usr/bin/env zsh

REPOSITORY="casey/just"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/just --completions zsh > ${LOCAL_CONFIG}/zsh/functions/_just
