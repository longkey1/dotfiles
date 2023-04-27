#!/usr/bin/env zsh

BINARY="tmpl"
REPOSITORY="longkey1/tmpl"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
#
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/tmpl/config.toml ${LOCAL_CONFIG}/tmpl/config.toml.dist -- envsubst '${HOME}' < ${LOCAL_CONFIG}/tmpl/config.toml.dist > ${LOCAL_CONFIG}/tmpl/config.toml
