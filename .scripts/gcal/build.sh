#!/usr/bin/env zsh

BINARY="gcal"
REPOSITORY="longkey1/gcal"
CURRENT=$(cd $(dirname $0);pwd)

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)

${LOCAL_BIN}/bw get notes 8dbf52a0-9ca9-41ec-8750-afeb004ce918 --session "${bw_session}" > ${LOCAL_CONFIG}/gcal/credentials.json
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/gcal/config.toml ${LOCAL_CONFIG}/gcal/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
