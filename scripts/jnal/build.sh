#!/usr/bin/env zsh

BINARY="jnal"
REPOSITORY="longkey1/jnal"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/jnal completion zsh > ${LOCAL_CONFIG}/zsh/functions/_jnal
