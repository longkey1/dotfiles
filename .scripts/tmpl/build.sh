#!/usr/bin/env zsh

BINARY="tmpl"
REPOSITORY="longkey1/tmpl"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/tmpl/config.toml ${LOCAL_CONFIG}/tmpl/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/tmpl --config ${LOCAL_CONFIG}/tmpl/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_tmpl
