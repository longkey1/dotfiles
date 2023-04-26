#!/usr/bin/env zsh

BINARY="gcal"
REPOSITORY="longkey1/gcal"

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/

${LOCAL_BIN)/bw get notes 8dbf52a0-9ca9-41ec-8750-afeb004ce918 > ${LOCAL_CONFIG}/gcal/credentials.json
${LOCAL_BIN)/checkexec gcal/config.toml ${LOCAL_CONFIG}/gcal/config.toml.dist -- envsubst '${HOME}' < ${LOCAL_CONFIG}/gcal/config.toml.dist > ${LOCAL_CONFIG}/gcal/config.toml
