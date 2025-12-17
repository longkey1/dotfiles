#!/usr/bin/env zsh

APP="got"
REPOSITORY="longkey1/${APP}"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/${APP}/config.toml ${LOCAL_CONFIG}/${APP}/config.toml.dist -- ${CURRENT}/build_config.sh

mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/${APP} --config ${LOCAL_CONFIG}/${APP}/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_${APP}
${LOCAL_BIN}/${APP} --config ${LOCAL_CONFIG}/${APP}/config.toml install
