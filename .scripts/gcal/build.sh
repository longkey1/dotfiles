#!/usr/bin/env zsh

REPOSITORY="longkey1/gcal"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)

${LOCAL_BIN}/bw get notes 8dbf52a0-9ca9-41ec-8750-afeb004ce918 --session "${bw_session}" > ${LOCAL_CONFIG}/gcal/credentials.json
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/gcal/config.toml ${LOCAL_CONFIG}/gcal/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/gcal --config ${LOCAL_CONFIG}/gcal/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_gcal
