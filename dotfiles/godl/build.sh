#!/usr/bin/env zsh

BINARY="godl"
REPOSITORY="longkey1/godl"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

$LOCAL_{BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/godl/config.toml ${LOCAL_CONFIG}/godl/config.toml.dist -- envsubst '${HOME}' < ${LOCAL_CONFIG}/godl/config.toml.dist > ${LOCAL_CONFIG}/godl/config.toml
${LOCAL_BIN}/godl install
