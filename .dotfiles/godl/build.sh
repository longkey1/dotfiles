#!/usr/bin/env zsh

BINARY="godl"
REPOSITORY="longkey1/godl"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  $LOCAL_{BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

#
CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/godl/config.toml ${LOCAL_CONFIG}/godl/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_envsubst.sh
${LOCAL_BIN}/godl install
