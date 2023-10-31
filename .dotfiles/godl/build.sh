#!/usr/bin/env zsh

BINARY="godl"
REPOSITORY="longkey1/godl"
CURRENT=$(cd $(dirname $0);pwd)

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/godl/config.toml ${LOCAL_CONFIG}/godl/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
${LOCAL_BIN}/godl install
