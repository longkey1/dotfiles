#!/usr/bin/env zsh

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)
${LOCAL_BIN}/bw get notes 8dbf52a0-9ca9-41ec-8750-afeb004ce918 --session "${bw_session}" > ${LOCAL_CONFIG}/gcal/credentials.json

envsubst '${HOME}' < ${LOCAL_CONFIG}/gcal/config.toml.dist > ${LOCAL_CONFIG}/gcal/config.toml
