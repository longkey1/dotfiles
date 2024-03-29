#!/usr/bin/env zsh

BINARY="jnal"
REPOSITORY="longkey1/jnal"
CURRENT=$(cd $(dirname $0);pwd)

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/jnal/config.toml ${LOCAL_CONFIG}/jnal/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
