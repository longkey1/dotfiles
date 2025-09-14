#!/usr/bin/env zsh

REPOSITORY="longkey1/gcal"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/gcal/config.toml ${LOCAL_CONFIG}/gcal/config.toml.dist -- ${CURRENT}/build_config.sh
mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/gcal --config ${LOCAL_CONFIG}/gcal/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_gcal