#!/usr/bin/env zsh

BINARY="tmpl"
REPOSITORY="longkey1/tmpl"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

#
CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/tmpl/config.toml ${LOCAL_CONFIG}/tmpl/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_envsubst.sh
