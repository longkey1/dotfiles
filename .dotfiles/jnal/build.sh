#!/usr/bin/env zsh

BINARY="jnal"
REPOSITORY="longkey1/jnal"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/jnal/config.toml ${LOCAL_CONFIG}/jnal/config.toml.dist -- envsubst '${HOME}' < ${LOCAL_CONFIG}/jnal/config.toml.dist > ${LOCAL_CONFIG}/jnal/config.toml
