#!/usr/bin/env zsh

BINARY="jnal"
REPOSITORY="longkey1/jnal"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/jnal/config.toml ${LOCAL_CONFIG}/jnal/config.toml.dist -- ${CURRENT}/build_config.sh
mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/jnal --config ${LOCAL_CONFIG}/jnal/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_jnal
