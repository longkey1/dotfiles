#!/usr/bin/env zsh

BINARY="tmpl"
REPOSITORY="longkey1/tmpl"
CURRENT=$(cd $(dirname $0);pwd)

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/tmpl/config.toml ${LOCAL_CONFIG}/tmpl/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
