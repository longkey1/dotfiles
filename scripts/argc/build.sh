#!/usr/bin/env zsh

REPOSITORY="sigoden/argc"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/argc --argc-completions zsh > ${LOCAL_CONFIG}/zsh/functions/_argc
