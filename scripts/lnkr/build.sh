#!/usr/bin/env zsh

REPOSITORY="longkey1/lnkr"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/lnkr completion zsh > ${LOCAL_CONFIG}/zsh/functions/_lnkr
